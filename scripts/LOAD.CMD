set echo on
compile lofchk
compile warmac,cishng,msg,setmsg,(nowarn)/f10 setup,@decwar,low,high
r link
@l
r link
@ldeb
