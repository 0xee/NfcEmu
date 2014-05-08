/*
 * cycfx2dev.cc - Cypress FX2 device class: low-level routines. 
 * 
 * Copyright (c) 2006--2009 by Wolfgang Wieser ] wwieser (a) gmx <*> de [ 
 * 
 * This file may be distributed and/or modified under the terms of the 
 * GNU General Public License version 2 as published by the Free Software 
 * Foundation. (See COPYING.GPL for details.)
 * 
 * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 * 
 */

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <iostream>

#include "cycfx2dev.h"


#define CMD_POLL_FW 0xC0
#define CMD_FW_OK 0xA1
#define CMD_RESET_FPGA 0xC1


using namespace std;

struct usb_device *USBFindDevice(const char *bus,const char *dev)
{
	for(usb_bus *b=usb_busses; b; b=b->next)
	{
		if(strcmp(b->dirname,bus))  continue;
		for(struct usb_device *d=b->devices; d; d=d->next)
		{
			if(strcmp(d->filename,dev))  continue;
			return(d);
		}
	}
	return(NULL);
}

struct usb_device *USBFindDevice(int vendor,int product,int nth)
{
	for(usb_bus *b=usb_busses; b; b=b->next)
	{
		for(struct usb_device *d=b->devices; d; d=d->next)
		{
//            cout << "vid: " << d->descriptor.idVendor
//                 << " pid: " << d->descriptor.idProduct << endl;
			if(d->descriptor.idVendor==vendor && 
				d->descriptor.idProduct==product)
			{
				if(!nth--)
				{  return(d);  }
			}
		}
	}
	return(NULL);
}

//------------------------------------------------------------------------------

int CypressFX2Device::Open(int const devNum) {
    int vendorId = 0x4b4;
    int productId = 0x8613;
    struct usb_device * fx2Dev = USBFindDevice(vendorId, productId, devNum);
    return OpenDevice(fx2Dev);
}

int CypressFX2Device::BlockRead(int endpoint,unsigned char *buf,size_t nbytes,
	char type)
{
	// FIXME: This function is somewhat bugged concerning reliable delivery 
	//        and correct handling of return values for short reads and . 
	//        timeout handling. Reason: Not sure what libusb is meant to 
	//        return and to do in non-standard cases. 
	
	if(!IsOpen())
	{  fprintf(stderr,"BlockRead: Not connected!\n");  return(-1);  }
	
	bool may_be_short=0;
	switch(type)
	{
		case 'b':  break;
		case 'i':  break;
		case 'B':  may_be_short=1;  type='b';  break;
		case 'I':  may_be_short=1;  type='i';  break;
		default:  assert(0);
	}
	
	int interface=0;
	int alt_interface=(type=='i' ? 2 : 1);
	if(force_alt_interface>=0)  alt_interface=force_alt_interface;
	if(usb_claim_interface(usbhdl,interface)<0)
	{  fprintf(stderr,"Failed to claim interface %d: %s\n",
		interface,usb_strerror());  return(-1);  }
	
	size_t chunk_size=nbytes;
	int error=0;
	size_t left=nbytes;
	do {
		if(usb_set_altinterface(usbhdl,alt_interface)<0)
		{
			fprintf(stderr,"Failed to set altinterface %d: %s\n",
				alt_interface,usb_strerror());
			++error;  break;
		}
		
		int ncalls=0;
		while(left)
		{
			size_t bs = left>chunk_size ? chunk_size : left;
			ssize_t rv;
			if(type=='i')
			{  rv=usb_interrupt_read(usbhdl,endpoint,(char*)buf,bs,
				/*timeout=*/1/*msec*/);  }
			else
			{  rv=usb_bulk_read(usbhdl,endpoint,(char*)buf,bs,
				/*timeout=*/1/*msec*/);  }
			++ncalls;
			if(rv<0)
			{
				// fprintf(stderr,"Reading %zu bytes from EP 0x%02x: "
				// 	"USB: %s SYS: %s\n",
				// 	bs,endpoint,usb_strerror(),strerror(-rv));
				++error;
				goto breakout;
			}
			assert((size_t)rv<=left);
			left-=rv;
			if((size_t)rv<bs)
			{
				if(may_be_short) goto breakout;
				
				// Not sure if rv=0 is a valid timeout indication...
				//if(!rv)
					// fprintf(stderr,"Short read (%zd/%zu bytes)%s\n",rv,bs,
					// 	rv==0 ? " (timeout?)" : "");
				if(rv==0)
				{  ++error;  goto breakout;  }
			}
		}
	} while(0); breakout:;
	
	usb_release_interface(usbhdl,interface);
	
	size_t read=nbytes-left;
	return(read ? read : (error ? -1 : 0));
}


int CypressFX2Device::BlockWrite(int endpoint,const unsigned char *buf,
	size_t nbytes,char type)
{
	// FIXME: This function is somewhat bugged concerning reliable delivery 
	//        and correct handling of return values for short writes and . 
	//        timeout handling. Reason: Not sure what libusb is meant to 
	//        return and to do in non-standard cases. 
	
	if(!IsOpen())
	{  fprintf(stderr,"BlockWrite: Not connected!\n");  return(-1);  }
	
	switch(type)
	{
		case 'b':  break;
		case 'i':  break;
		default:  assert(0);
	}
	
	int interface=0;
	int alt_interface=(type=='i' ? 2 : 1);
	if(force_alt_interface>=0)  alt_interface=force_alt_interface;
	if(usb_claim_interface(usbhdl,interface)<0)
	{  fprintf(stderr,"Failed to claim interface %d: %s\n",
		interface,usb_strerror());  return(-1);  }
	
	size_t chunk_size=nbytes;
	int error=0;
	size_t left=nbytes;
	do {
		if(usb_set_altinterface(usbhdl,alt_interface)<0)
		{
			fprintf(stderr,"Failed to set altinterface %d: %s\n",
				alt_interface,usb_strerror());
			++error;  break;
		}
		
		int ncalls=0;
		while(left)
		{
			size_t bs = left>chunk_size ? chunk_size : left;
			ssize_t rv;
			if(type=='i')
			{  rv=usb_interrupt_write(usbhdl,endpoint,(char*)buf,bs,
				/*timeout=*/10/*msec*/);  }
			else
			{  rv=usb_bulk_write(usbhdl,endpoint,(char*)buf,bs,
				/*timeout=*/10/*msec*/);  }
			++ncalls;
			if(rv<0)
			{
				fprintf(stderr,"Writing %zu bytes to EP 0x%02x: "
					"USB: %s SYS: %s\n",
					bs,endpoint,usb_strerror(),strerror(-rv));
				++error;
				goto breakout;
			}
			assert((size_t)rv<=left);
			left-=rv;
			if((size_t)rv<bs)
			{
				// Not sure if rv=0 is a valid timeout indication...
				//if(!rv)
					fprintf(stderr,"Short write (%zd/%zu bytes)%s\n",rv,bs,
						rv==0 ? " (timeout?)" : "");
				if(rv==0)
				{  ++error;  goto breakout;  }
			}
		}
	} while(0); breakout:;
	
	usb_release_interface(usbhdl,interface);
	
	size_t read=nbytes-left;
	return(read ? read : (error ? -1 : 0));
}


int CypressFX2Device::BenchBlockRead(int endpoint,size_t nbytes,
	size_t chunk_size,char type)
{
	if(!IsOpen())
	{  fprintf(stderr,"BenchBlockRead: Not connected!\n");  return(1);  }
	
	assert(type=='b' || type=='i');
	
	int interface=0;
	int alt_interface=(type=='i' ? 2 : 1);
	if(force_alt_interface>=0)  alt_interface=force_alt_interface;
	if(usb_claim_interface(usbhdl,interface)<0)
	{  fprintf(stderr,"Failed to claim interface %d: %s\n",
		interface,usb_strerror());  return(1);  }
	
	int error=0;
	char *buf=(char*)malloc(chunk_size);
	assert(buf);
	do {
		if(usb_set_altinterface(usbhdl,alt_interface)<0)
		{
			fprintf(stderr,"Failed to set altinterface %d: %s\n",
				alt_interface,usb_strerror());
			++error;  break;
		}
		
		// Start benchmark: 
		timeval start_tv,end_tv;
		gettimeofday(&start_tv,NULL);
		
		size_t left=nbytes;
		int ncalls=0;
		while(left)
		{
			size_t bs = left>chunk_size ? chunk_size : left;
			ssize_t rv;
			if(type=='i')
			{  rv=usb_interrupt_read(usbhdl,endpoint,buf,bs,
				/*timeout=*/1/*msec*/);  }
			else
			{  rv=usb_bulk_read(usbhdl,endpoint,buf,bs,
				/*timeout=*/1/*msec*/);  }
			++ncalls;
			if(rv<0)
			{
				fprintf(stderr,"Reading %zu bytes from EP 0x%02x: "
					"USB: %s SYS: %s\n",
					bs,endpoint,usb_strerror(),strerror(-rv));
				++error;
				goto breakout;
			}
			if((size_t)rv<bs)
			{
				// Not sure if rv=0 is a valid timeout indication...
				//if(!rv)
					fprintf(stderr,"Short read (%zd/%zu bytes)%s\n",rv,bs,
						rv==0 ? " (timeout?)" : "");
				if(rv==0)
				{  ++error;  goto breakout;  }
			}
			assert((size_t)rv<=left);
			left-=rv;
		}
		
		// End benchmark: 
		gettimeofday(&end_tv,NULL);
		
		double seconds = 
			double(end_tv.tv_sec-start_tv.tv_sec)+
			double(end_tv.tv_usec-start_tv.tv_usec)/1000000.0;
		printf("Read %zu bytes in %5d msec (chunk size %6zu): "
			"%6.3f Mb/sec (%5d calls, %6zu bytes/call)\n",
			nbytes,(int)(seconds*1000+0.5),
			chunk_size,nbytes/seconds/1024/1024,
			ncalls,nbytes/ncalls);
		
	} while(0); breakout:;
	
	if(buf)
	{  free(buf);  buf=NULL;  }
	usb_release_interface(usbhdl,interface);
	
	return(error ? -1 : 0);
}


int CypressFX2Device::FX2Reset(bool running)
{
	// Reset is accomplished by writing a 1 to address 0xE600. 
	// Start running by writing a 0 to that address. 
	const size_t reset_addr=0xe600;
	unsigned char val = running ? 0 : 1;
	
	return(WriteRAM(reset_addr,&val,1));
}


int CypressFX2Device::WriteRAM(size_t addr,const unsigned char *data,
	size_t nbytes)
{
	if(!IsOpen())
	{  fprintf(stderr,"WriteRAM: Not connected!\n");  return(1);  }
	
	int n_errors=0;
	
	const size_t chunk_size=16;
	const unsigned char *d=data;
	const unsigned char *dend=data+nbytes;
	while(d<dend)
	{
		size_t bs=dend-d;
		if(bs>chunk_size)  bs=chunk_size;
		size_t dl_addr=addr+(d-data);
		int rv=usb_control_msg(usbhdl,0x40,0xa0,
			/*addr=*/dl_addr,0,
			/*buf=*/(char*)d,/*size=*/bs,
			/*timeout=*/1000/*msec*/);
		if(rv<0)
		{  fprintf(stderr,"Writing %zu bytes at 0x%zx: %s\n",
			bs,dl_addr,usb_strerror());  ++n_errors;  }
		d+=bs;
	}
	
	return(n_errors);
}


int CypressFX2Device::ReadRAM(size_t addr,unsigned char *data,size_t nbytes)
{
	if(!IsOpen())
	{  fprintf(stderr,"ReadRAM: Not connected!\n");  return(1);  }
	
	int n_errors=0;
	
	const size_t chunk_size=16;
	
	unsigned char *d=data;
	unsigned char *dend=data+nbytes;
	while(d<dend)
	{
		size_t bs=dend-d;
		if(bs>chunk_size)  bs=chunk_size;
		size_t rd_addr=addr+(d-data);
		int rv=usb_control_msg(usbhdl,0xc0,0xa0,
			/*addr=*/rd_addr,0,
			/*buf=*/(char*)d,/*size=*/bs,
			/*timeout=*/1000/*msec*/);
		if(rv<0)
		{  fprintf(stderr,"Reading %zu bytes at 0x%zx: %s\n",
			bs,rd_addr,usb_strerror());  ++n_errors;  }
		d+=bs;
	}
	
	return(n_errors);
}


int CypressFX2Device::_ProgramIHexLine(const char *buf,
	const char *path,int line)
{
	const char *s=buf;
	if(*s!=':')
	{  fprintf(stderr,"%s:%d: format violation (1)\n",path,line);
		return(1);  }
	++s;
	
	unsigned int nbytes=0,addr=0,type=0;
	if(sscanf(s,"%02x%04x%02x",&nbytes,&addr,&type)!=3)
	{  fprintf(stderr,"%s:%d: format violation (2)\n",path,line);
		return(1);  }
	s+=8;
	
	if(type==0)
	{
		//printf("  Writing nbytes=%d at addr=0x%04x\n",nbytes,addr);
		assert(nbytes>=0 && nbytes<256);
		unsigned char data[nbytes];
		unsigned char cksum=nbytes+addr+(addr>>8)+type;
		for(unsigned int i=0; i<nbytes; i++)
		{
			unsigned int d=0;
			if(sscanf(s,"%02x",&d)!=1)
			{  fprintf(stderr,"%s:%d: format violation (3)\n",path,line);
				return(1);  }
			s+=2;
			data[i]=d;
			cksum+=d;
		}
		unsigned int file_cksum=0;
		if(sscanf(s,"%02x",&file_cksum)!=1)
		{  fprintf(stderr,"%s:%d: format violation (4)\n",path,line);
			return(1);  }
		if((cksum+file_cksum)&0xff)
		{  fprintf(stderr,"%s:%d: checksum mismatch (%u/%u)\n",
			path,line,cksum,file_cksum);  return(1);  }
		if(WriteRAM(addr,data,nbytes))
		{  return(1);  }
	}
	else if(type==1)
	{
		// EOF marker. Oh well, trust it. 
		return(-1);
	}
	else
	{
		fprintf(stderr,"%s:%d: Unknown entry type %d\n",path,line,type);
		return(1);
	}

	return(0);
}


int CypressFX2Device::ProgramIHexFile(const char *path)
{
	if(!IsOpen())
	{  fprintf(stderr,"ProgramIHexFile: Not connected!\n");  return(1);  }
	
	FILE *fp=fopen(path,"r");
	if(!fp)
	{  fprintf(stderr,"Failed to open %s: %s\n",path,strerror(errno));
		return(2);  }
	
	int n_errors=0;
	
	const size_t buflen=1024;  // Hopefully much too long for real life...
	char buf[buflen];
	int line=1;
	for(;;++line)
	{
		*buf='\0';
		if(!fgets(buf,buflen,fp))
		{
			if(feof(fp))
			{  break;  }
			fprintf(stderr,"Reading %s (line %d): %s\n",path,line,
				strerror(ferror(fp)));
			fclose(fp);  fp=NULL;
			return(3);
		}
		
		int rv=_ProgramIHexLine(buf,path,line);
		if(rv<0)  break;
		if(rv)
		{  ++n_errors;  }
	}
	
	if(fp)
	{  fclose(fp);  }
	
	return(n_errors ? -1 : 0);
}


int CypressFX2Device::ProgramStaticIHex(const char **ihex)
{
	int n_errors=0;
	
	for(int line=0; ihex[line]; line++)
	{
		int rv=_ProgramIHexLine(ihex[line],"[builtin]",line+1);
		if(rv<0)  break;
		if(rv)
		{  ++n_errors;  }
	}
	
	return(n_errors ? -1 : 0);
}


int CypressFX2Device::ProgramBinFile(const char *path,size_t start_addr)
{
	if(!IsOpen())
	{  fprintf(stderr,"ProgramIHexFile: Not connected!\n");  return(1);  }
	
	int fd=::open(path,O_RDONLY);
	if(fd<0)
	{  fprintf(stderr,"Failed to open %s: %s\n",path,strerror(errno));
		return(2);  }
	
	int n_errors=0;
	const size_t buflen=1024;
	char buf[buflen];
	size_t addr=start_addr;
	for(;;)
	{
		ssize_t rd=read(fd,buf,buflen);
		if(!rd)  break;
		if(rd<0)
		{
			fprintf(stderr,"Reading %s: %s\n",path,strerror(errno));
			::close(fd);  fd=-1;
			return(3);
		}
		if(WriteRAM(addr,(const unsigned char*)buf,rd))
		{  ++n_errors;  }
		addr+=rd;
	}
	
	if(fd>=0)
	{  ::close(fd);  fd=-1;  }
	
	return(n_errors ? -1 : 0);
}


int CypressFX2Device::CtrlMsg(unsigned char requesttype,
	unsigned char request,int value,int index,
	const unsigned char *ctl_buf,size_t ctl_buf_size)
{
	if(!IsOpen())
	{  fprintf(stderr,"CtrlMsg: Not connected!\n");  return(1);  }
	
	int n_errors=0;
	
	int rv=usb_control_msg(usbhdl,requesttype,request,
		value,index,
		(char*)ctl_buf,ctl_buf_size,
		/*timeout=*/1000/*msec*/);
	if(rv<0)
	{  fprintf(stderr,"Sending USB control message: %s\n",
		usb_strerror());  ++n_errors;  }
	
	return(n_errors);
}


int CypressFX2Device::OpenDevice(struct usb_device *_usbdev)
{
	Close();
	usbdev=_usbdev;
    if(!usbdev) {
        return 1;
    }
    usbhdl=usb_open(usbdev);
    if(!usbhdl)
    {
        fprintf(stderr,"Failed to open device: %s\n",usb_strerror());
		return 1;
    }
	return 0;
}


int CypressFX2Device::Close()
{
	int rv=0;
	if(usbhdl)
	{
		rv=usb_close(usbhdl);  usbhdl=NULL;
		if(rv)
		{  fprintf(stderr,"closing USB device: %s\n",usb_strerror());  }
	}
	usbdev=NULL;
	return(rv);
}


void CypressFX2Device::FlushInputBuffer(unsigned int const epIn) {
    int rx;
    char rxBuf[1024];
    do {
        rx = BlockRead(epIn,(unsigned char *)rxBuf, 1, 'B');
    } while(rx>0);
}

void CypressFX2Device::ResetFpga() {
    unsigned char buf[1<<10];
    buf[0] = CMD_RESET_FPGA;
    int ret = BlockWrite(0x01, buf, 1, 'b');
    do {        
        ret = BlockRead(0x86, buf, sizeof(buf), 'B');        
        usleep(10000);
    } while(ret > 0);


}

bool CypressFX2Device::CheckFw() {

    unsigned char c = CMD_POLL_FW;

    int ret = BlockWrite(1, (unsigned char *)&c, 1, 'b');
    usleep(10000);
    ret = BlockRead(0x81, (unsigned char *)&c, 1, 'B');

    return c == CMD_FW_OK;
}
