ON ERROR
CLEAR 
oInfoRedes = CREATEOBJECT("infoRedes",'inforedes.txt')

lcvalor = oInfoRedes.getipPublica()
? 'ipPublica ' + lcValor
? 'ipLan v.4 ' + oInfoRedes.getipLANv4()
? 'ip Server ' + oInfoRedes.getDHCPServer()

RETURN 

*---------------------------------------------------------------
* Author: Raúl Juárez
* e-Mail: raul.jrz@gmail.com
* github: github.com/raul.jrz
* Dt &Tm: 2017.10.29 - 13:00 pm
* Coment:
*         Optiene los datos de la Placa de Red y la IP de la LAN en version 4 y 6 mas 
*         la IP externa (Internet) 
*         Ademas, si se pasa como parametro el nombre de un archivo al crear el objecto se guarda en el el log
*     
*         oInfoRedes = CREATEOBJECT("infoRedes",'loginforedes.txt')
*     
* Metods: getipPublica(), getipLANv4(), getipLANv6(), getDNSHostName(), getMACAddress(), getDefaultIPGateway(), getDHCPServer()
DEFINE CLASS infoRedes AS CUSTOM
*---------------------------------------------------------------
	PROTECTED ipPublica, cntPlacas, bLogActivate, cLogFileName, cOldPrint
	DIMENSION ipLANv4(1), ipLANv6(1), DefaultIPGateway(1), Description(1),;
			  DHCPServer(1), DNSDomain(1), DNSHostName(1), IPSubnet(1), MACAddress(1)
	cntPlacas = 0
	cOldPrint = ''     && Configuración inicial de PRINT
	bLogActivate=.F.   && Indica si se guarda o no los log de los metodos del init
 	cLogFileName=''    && Es el nombre con el path del archivo en donde guardar el log.
	
	*---------------------------------------------------------------
	FUNCTION init
	*---------------------------------------------------------------
		LPARAMETERS tcLog
		
		WITH THIS
			IF PARAMETERS()>0 AND VARTYPE("tcLog")="C" THEN
				.bLogActivate=.F.
				.cLogFileName=tcLog
			ENDIF
			
			*---- Para habilitar los logs si es necesario
			.logProcess()
			*----
			
			.obtenerIPPublica()
			.obtenerIPLAN()
			
			*--- Para deshabilitar los logs si estuvieran activos
			.logProcess()
		*---
		ENDWITH
	ENDFUNC
	
	*---------------------------------------------------------------
	FUNCTION getipPublica
	*---------------------------------------------------------------
	RETURN THIS.ipPublica

	*---------------------------------------------------------------
	FUNCTION getipLANv4
	*---------------------------------------------------------------
	RETURN THIS.ipLANv4(1)

	*---------------------------------------------------------------
	FUNCTION getipLANv6
	*---------------------------------------------------------------
	RETURN THIS.ipLANv6(1)
	
	*---------------------------------------------------------------
	FUNCTION getDNSHostName
	*---------------------------------------------------------------
	RETURN THIS.DNSHostName(1)
	
	*---------------------------------------------------------------
	FUNCTION getMACAddress
	*---------------------------------------------------------------
	RETURN THIS.MACAddress(1)
	
	*---------------------------------------------------------------
	FUNCTION getDefaultIPGateway
	*---------------------------------------------------------------
	RETURN THIS.DefaultIPGateway(1)
	
	*---------------------------------------------------------------
	FUNCTION getDHCPServer
	*---------------------------------------------------------------
	RETURN THIS.DHCPServer(1)
		
	*---------------------------------------------------------------
	PROTECTED FUNCTION logProcess()
	* Gestiona el archivo log de los procesos de busqueda de las IP
	*---------------------------------------------------------------
		IF !THIS.bLogActivate THEN
			IF !EMPTY(THIS.cLogFileName) THEN
				THIS.cOldPrint = SET("Printer")
				SET CONSOLE OFF

				SET PRINTER TO (THIS.cLogFileName)
				SET PRINTER ON
				THIS.bLogActivate = .T.
			ENDIF
		ELSE
			THIS.bLogActivate = .F.
			SET PRINTER OFF
			SET PRINTER TO (this.cOldPrint)
		ENDIF
	ENDFUNC 

	*---------------------------------------------------------------
	PROTECTED FUNCTION obtenerIPLAN
	* Usando WMI obtengo todos los datos de las placas de red
	*---------------------------------------------------------------
		WAIT WINDOW '¡Preparando entorno para obtener datos de las placas!' NOWAIT
		objWMIService = GETOBJECT("winmgmts:")
		oAdapters = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=True")

		THIS.cntPlacas = 0
		FOR EACH objItem IN oAdapters
			WAIT WINDOWS 'Procesando datos de las placas de red... Espere!' NOWAIT
			
			THIS.cntPlacas = THIS.cntPlacas + 1
			DIMENSION THIS.ipLANv4(THIS.cntPlacas),    THIS.ipLANv6(THIS.cntPlacas),    THIS.DefaultIPGateway(THIS.cntPlacas),;
					  THIS.Description(THIS.cntPlacas),THIS.DHCPServer(THIS.cntPlacas), THIS.DNSDomain(THIS.cntPlacas),;
					  THIS.DNSHostName(THIS.cntPlacas),THIS.IPSubnet(THIS.cntPlacas),   THIS.MACAddress(THIS.cntPlacas)

			THIS.ipLANv4    (THIS.cntPlacas) = objItem.ipaddress(0)
			THIS.ipLANv6    (THIS.cntPlacas) = objItem.ipaddress(1)
			THIS.DefaultIPGateway(THIS.cntPlacas) = IIF(VARTYPE(objItem.DefaultIPGateway(0))='C',objItem.DefaultIPGateway(0),'')
			THIS.Description(THIS.cntPlacas) = objItem.DESCRIPTION
			THIS.DHCPServer (THIS.cntPlacas) = objItem.DHCPServer
			THIS.DNSDomain  (THIS.cntPlacas) = objItem.DNSDomain
			THIS.DNSHostName(THIS.cntPlacas) = objItem.DNSHostName
			THIS.IPSubnet   (THIS.cntPlacas) = objItem.IPSubnet(0)
			THIS.MACAddress (THIS.cntPlacas) = objItem.MACAddress
			
			IF THIS.bLogActivate
  				? ""
  				? "-----------------------------------"
  				? "Win32_NetworkAdapterConfiguration instance"
  				? "-----------------------------------"
  				? "DefaultIPGateway: " 
  				?? IIF(VARTYPE(objItem.DefaultIPGateway(0))='C',objItem.DefaultIPGateway(0),'')
  				? "Description: " 
  				?? objItem.DESCRIPTION
  				? "DHCPEnabled: "
  				?? objItem.DHCPEnabled
  				? "DHCPLeaseExpires: " 
  				?? objItem.DHCPLeaseExpires
  				? "DHCPLeaseObtained: " 
  				?? objItem.DHCPLeaseObtained
  				? "DHCPServer: " 
  				?? objItem.DHCPServer
  				? "DNSDomain: " 
  				?? objItem.DNSDomain
  				? "DNSHostName: " 
  				?? objItem.DNSHostName
  				? "IPAddress: IPv4: " 
  				?? objItem.ipaddress(0)
  				?? " - IPv6: " 
  				?? objItem.ipaddress(1)
  				? "IPSubnet: " 
  				?? objItem.IPSubnet(0)
  				? "MACAddress: " 
  				?? objItem.MACAddress
			ENDIF &&THIS.THIS.bLogActivate

		ENDFOR
		RELEASE objWMIService
		
	ENDFUNC
	
	*---------------------------------------------------------------
	PROTECTED FUNCTION obtenerIPPublica
	* Usando InternetExplorer.Application, se conecta a http://whatismyip.org
	*---------------------------------------------------------------
		LOCAL jcTextoHtml, jcReturn, lnStart 

		jcReturn = '*IP no detectada*'
		jcTextoHtml='* not response *'
		lnStart    = 0
		DECLARE Sleep IN win32api INTEGER
		loIE = CREATEOBJECT('InternetExplorer.Application')
		loIE.Navigate2('http://whatismyip.org')

		WAIT WINDOWS 'Obteniendo IP Publica... espere' NOWAIT
		lnStart = SECONDS()
		DO WHILE loIE.Busy AND SECONDS() - lnStart < 15 && 15 Segs.
			Sleep(1000)
		ENDDO
		WAIT CLEAR

		IF loIE.Busy
			jcReturn = '*ERROR al buscar IP'
		ELSE
			jcTextoHtml = loIE.DOCUMENT.Body.InnerText
			jcMyIP=STRTRAN(CHRTRAN(LOWER(jcTextoHtml),'abcdefghijklmnopqrstuvwxyz:?(){}[],;=|'+CHR(13)+CHR(10)+CHR(9),SPACE(100)),' ','')

			jcMyIP=ALLTRIM(STRTRAN(jcMyIP,'....',' '))
			jcReturn = jcMyIP
		ENDIF  &&loIE.Busy
		RELEASE loIE
		
		THIS.ipPublica = jcReturn
		
		IF THIS.bLogActivate
			? '------------------------------------------------------'
			? ' Public IP (Internet): '
			?? THIS.ipPublica
			? '------------------------------------------------------'
			? ' RESPONSE: '
			? STRTRAN(jcTextoHtml,CHR(10),CHR(13))
		ENDIF

	ENDFUNC
ENDDEFINE 

