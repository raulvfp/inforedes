 */
 * @since:  1.0
 *
 * @author: Raúl Juárez <raul.jrz@gmail.com>
 * @date:   2017.10.28
 */
DEFINE CLASS infoRedesTest as FxuTestCase OF FxuTestCase.prg
*----------------------------------------------------------------------

	#IF .f.
	LOCAL THIS AS infoRedesTest OF infoRedesTest.PRG
	#ENDIF
	oObject = ''  &&Este es el objecto que va a ser evaluado

	*-Definicion de Propiedades
	real_ipLANv4     = '192.168.100.105'
	real_ipLANv6     = 'fe80::8c19:d05c:f993:c239'
	real_DefaultIPGateway = '192.168.100.1'
	real_Description = 'Atheros AR5B97 Wireless Network Adapter'
	real_DHCPServer  = '192.168.100.1'
	real_DNSDomain   = .NULL.
	real_DNSHostName = 'note-raul'
	real_IPSubnet    = '255.255.255.0'
	real_MACAddress  = '4C:0F:6E:6B:74:63'
	
	real_IPPublica   = '186.158.222.155'
	
	*--------------------------------------------------------------------
	FUNCTION Setup
	*--------------------------------------------------------------------
		SET PROCEDURE TO Z:\compartido\Dropbox\sistema\turnos\progs\inforedes.prg
		THIS.oObject = CREATEOBJECT('inforedes')
	ENDFUNC
	*--------------------------------------------------------------------
	
	*---------------------------------------------------------------------
	FUNCTION testExisteObjecto()
	* Verifica la existencia del objecto...
	*---------------------------------------------------------------------
		THIS.AssertNotNull('No existe el objecto',THIS.oObject)
	ENDFUNC
	*---------------------------------------------------------------------

	*---------------------------------------------------------------------
	FUNCTION testVerify_the_Existence_ofthe_propieted_and_ValueIPv4and6()
	*---------------------------------------------------------------------
		*THIS.oOBJECT.obtenerIPLAN()
		
		THIS.assertnotempty(THIS.oObject.ipLANv4[1])
		THIS.assertequals(THIS.real_ipLANv4,THIS.oObject.ipLANv4[1],;
				'ERROR, ip LAN v4 no valida')
				
		THIS.assertnotempty(THIS.oObject.ipLANv6[1])
		THIS.assertequals(THIS.real_ipLANv6,THIS.oObject.ipLANv6[1],;
				'ERROR, ip LAN v6 no válida')
				
		THIS.assertnotempty(THIS.oObject.DHCPServer[1])
		THIS.assertequals(THIS.real_DHCPServer,THIS.oObject.DHCPServer[1],;
				'ERROR DHCP '+THIS.oObject.DHCPServer[1])	
	ENDFUNC
	*---------------------------------------------------------------------

	*---------------------------------------------------------------------
	FUNCTION testVerify_the_Existence_ofthe_getmethod_and_Value()
	*---------------------------------------------------------------------
		THIS.assertNotEmpty(THIS.oObject.getipPublica())
		THIS.assertequals(THIS.real_IPPublica,THIS.oObject.getipPublica(),;
				'ERROR IP Publica '+THIS.oObject.getipPublica())
				
		THIS.assertNotEmpty(THIS.oObject.getipLANv4())
		THIS.AssertEquals(THIS.real_ipLANv4, THIS.oObject.getipLANv4(),;
				'ERROR, ip LAN v4 no valida')
				
		THIS.assertNotEmpty(THIS.oObject.getipLANv6())
		THIS.AssertEquals(THIS.real_ipLANv6, THIS.oObject.getipLANv6(),;
				'ERROR, ip LAN v6 no válida')
		
		THIS.assertNotEmpty(THIS.oObject.getDNSHostName())
	ENDFUNC
	*---------------------------------------------------------------------
	
	*--------------------------------------------------------------------
	FUNCTION TearDown
	*--------------------------------------------------------------------

	
	ENDFUNC
	*--------------------------------------------------------------------	



ENDDEFINE
*----------------------------------------------------------------------
