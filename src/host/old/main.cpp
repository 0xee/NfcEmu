#include <iostream>
#include <string>
#include <termios.h>
#include <signal.h>
#include <cstdio>
#include "ccolor.h"
#include "DeviceManager.h"
#include "NfcSniffer.h"
#include "Iso14443aPicc.h"
#include "Configuration.h"
#include "RawDataRecorder.h"

#define EXIT_SUCCESS 0
#define EXIT_ERROR   1

using namespace std;

char getch();
void InitSignalHandling();
void Plot(string const & file, size_t const samples = 1<<20);


void CommTest(NfcEmuRole & r) {
    
    NfcPacketTranslator tr = r.GetDevice();
    vector<unsigned char> v = {1, 2, 3};
    tr.SendPacket(NfcEmuPacket(UnitId::eL4CpuDebug, v.begin(), v.end()));

    tr.WaitForPacket(1, true);
    while(tr.ReceivePacket(true));
// //    getch();
//     exit(0);
}

static bool mainLoopRunning = false;

int main(int argc, char * argv[]) {

    InitSignalHandling();

    auto pCfg = shared_ptr<Configuration>(new Configuration(argc,argv));

    pCfg->RegisterFlag("no-color", "nc", false);
    cc::Enable(!pCfg->GetFlag("no-color"));

    DeviceManager devMgr(pCfg);
    
    
    std::shared_ptr<NfcEmuDevice> pDev;

    try {
        pDev = devMgr.ConstructDevice();
    } catch(std::exception & e) {
        cout << e.what() << endl;
        return EXIT_ERROR;
    }

    if(!pDev) return EXIT_ERROR;

    //cout << *pCfg;

    //size_t megToRecord = 1;
    //opts.GetOption(megToRecord, "msamples", "s"); 
    //megToRecord *= 1<<20;
    unique_ptr<NfcEmuRole> pRole;
    switch(ModeFromString(pCfg->GetMode("sniffer"))) {

    case eAmDemodMode:
    {
        pCfg->RegisterOption("msamples", "ms", 0);
        pCfg->RegisterOption("samples", "s", 1<<20);
        size_t samples = pCfg->GetOption("msamples");
        if(samples) samples <<= 20;
        else samples = pCfg->GetOption("samples");
        RawDataRecorder rec(pDev, pCfg->GetOption("outfile"));
        rec.Record(samples);
        pCfg->RegisterFlag("plot", "plot", false);
        if(pCfg->GetFlag("plot")) {
            Plot(pCfg->GetOption("outfile"), samples/16);
        }
        return EXIT_SUCCESS;
    }
    
    case eNfcSnifferMode: 
        pRole = unique_ptr<NfcEmuRole>(
            new NfcSniffer(unique_ptr<NfcPacketTranslator>(new NfcPacketTranslator(pDev)),
                           "sniffer.log"));
        break;

    case eIso14443aPiccMode:
        
        pRole = unique_ptr<NfcEmuRole>(
            new Iso14443aPicc(unique_ptr<NfcPacketTranslator>(new NfcPacketTranslator(pDev))));
        break;
        
    default:
        cerr << "Invalid mode, exiting" << endl;
        exit(EXIT_ERROR);
    }

    CommTest(*pRole);

    
    cout << ":: Entering main loop" << endl;
    mainLoopRunning = true;
    while(mainLoopRunning) {
        pRole->ProcessData();
        usleep(1000);
    };
   


    return EXIT_SUCCESS;
} 



void SignalHandler(int s){
    cout << endl << "Caught "; 
    
    switch(s) {
    case SIGINT:
        cout << "SIGINT";
        break;
    case SIGTERM:
        cout << "SIGTERM";
        break;
    default:
        cout << "signal " << s;
        break;
    }
    cout << ", exiting" << endl;
    if(mainLoopRunning) {
        mainLoopRunning = false;
    } else {
        exit(0);
    }        
}


void InitSignalHandling() {
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = SignalHandler;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
    sigaction(SIGINT, &sigIntHandler, NULL);
    sigaction(SIGTERM, &sigIntHandler, NULL);
}

char getch(){
    /*#include <unistd.h>   //_getch*/
    /*#include <termios.h>  //_getch*/
    char buf=0;
    termios old={0};
    fflush(stdout);
    if(tcgetattr(0, &old)<0)
        perror("tcsetattr()");
    old.c_lflag&=~ICANON;
    old.c_lflag&=~ECHO;
    old.c_cc[VMIN]=1;
    old.c_cc[VTIME]=0;
    if(tcsetattr(0, TCSANOW, &old)<0)
        perror("tcsetattr ICANON");
    if(read(0,&buf,1)<0)
        perror("read()");
    old.c_lflag|=ICANON;
    old.c_lflag|=ECHO;
    if(tcsetattr(0, TCSADRAIN, &old)<0)
        perror ("tcsetattr ~ICANON");
    printf("%c\n",buf);
    return buf;
 }


FILE* start_gnuplot(size_t const samples);

void Plot(string const & file, size_t const samples) {

    ifstream ifs(file.c_str());
    
    FILE * fout = start_gnuplot(samples);

        fprintf( fout, "plot \"-\" notitle\n" );

        while(!ifs.eof()) {
            int i;
            ifs >> i;
            fprintf( fout, "%d\n", i);
        }
        fprintf( fout, "e\n" ); //the gnuplot window doesn't open until it
}

FILE* start_gnuplot(size_t const samples)
{
  FILE* output;
  int pipes[2];
  pid_t pid;

  pipe( pipes );
  pid = fork ();

  if ( !pid )
    {
      dup2( pipes[0], STDIN_FILENO );
      execlp( "gnuplot", NULL );
      exit(1);
    }

  output = fdopen( pipes[1], "w" );

  fprintf (output, "set xrange [0:%d]\n", samples );
  fprintf (output, "set yrange [0:255]\n" );
  fprintf (output, "set xtics 10\n");
  fprintf (output, "set ytics 10\n");
  fprintf (output, "set ylabel \"Value\"\n");
  fprintf (output, "set style data lines\n" );
  fprintf (output, "set grid\n" );
  fflush (output);

  return output;
}

