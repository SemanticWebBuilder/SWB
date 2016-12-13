/**
* SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integración,
* colaboración y conocimiento, que gracias al uso de tecnología semántica puede generar contextos de
* información alrededor de algún tema de interés o bien integrar información y aplicaciones de diferentes
* fuentes, donde a la información se le asigna un significado, de forma que pueda ser interpretada y
* procesada por personas y/o sistemas, es una creación original del Fondo de Información y Documentación
* para la Industria INFOTEC, cuyo registro se encuentra actualmente en trámite.
*
* INFOTEC pone a su disposición la herramienta SemanticWebBuilder a través de su licenciamiento abierto al público (‘open source’),
* en virtud del cual, usted podrá usarlo en las mismas condiciones con que INFOTEC lo ha diseñado y puesto a su disposición;
* aprender de él; distribuirlo a terceros; acceder a su código fuente y modificarlo, y combinarlo o enlazarlo con otro software,
* todo ello de conformidad con los términos y condiciones de la LICENCIA ABIERTA AL PÚBLICO que otorga INFOTEC para la utilización
* del SemanticWebBuilder 4.0.
*
* INFOTEC no otorga garantía sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni implícita ni explícita,
* siendo usted completamente responsable de la utilización que le dé y asumiendo la totalidad de los riesgos que puedan derivar
* de la misma.
*
* Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposición la siguiente
* dirección electrónica:
*  http://www.semanticwebbuilder.org
**/

import org.semanticwb.model.User
import org.semanticwb.model.WebPage
import org.semanticwb.SWBPlatform;
import org.semanticwb.portal.api.SWBResourceURL


def context=org.semanticwb.SWBPortal.getContextPath();
def login="";if(request.getParameter("login")!=null) login=request.getParameter("login");
def pwd="";if(request.getParameter("pwd")!=null) pwd=request.getParameter("pwd");
def firstName="";if(request.getParameter("firstName")!=null) firstName=request.getParameter("firstName");
def lastName="";if(request.getParameter("lastName")!=null) lastName=request.getParameter("lastName");
def secondLastName="";if(request.getParameter("secondLastName")!=null) secondLastName=request.getParameter("secondLastName");
def email="";if(request.getParameter("email")!=null) email=request.getParameter("email");

def paramRequest=request.getAttribute("paramRequest")
User user = paramRequest.getUser()
WebPage wpage=paramRequest.getWebPage()
String contextPath=SWBPlatform.getContextPath();
def url = paramRequest.getActionUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setAction("create").setMode(SWBResourceURL.Mode_EDIT)
def repository = wpage.getWebSite().getUserRepository().getId()

println """<script type="text/javascript">
           dojo.require("dojo.parser");
                   dojo.require("dijit.layout.ContentPane");
                   dojo.require("dijit.form.Form");
                   dojo.require("dijit.form.ValidationTextBox");
                   dojo.require("dijit.form.Button");
                   init('$context');
        </script>
<form id="org.semanticwb.community.User/com/create" dojoType="dijit.form.Form" class="swbform"
action="$url" 
method="POST">
<div class="adminTools">
                    <p><a  class="adminTool"href="javascript:enviar()">Guardar</a>&nbsp;&nbsp;&nbsp;&nbsp;<a  class="adminTool"href="javascript:history.back();">Cancelar</a></p>
                    </div>
<fieldset><legend>Registro de Nuevo Usuario</legend>
	<table>
		<tr>
			<td align="right">
				<label>Usuario <em>*</em></label>
			</td>
			<td><input type="text" name="login" dojoType="dijit.form.ValidationTextBox" value="$login"
                        required="true" promptMessage="Captura identificador de usuario."
                        invalidMessage="El identificador de usuario es invalido o ya existe."
                        isValid="return canAddLogin('$repository',this.textbox.value);" trim="true" />
			</td>
		</tr>
		<tr>
			<td align="right">
				<label>Contrase&ntilde;a <em>*</em></label>
			</td>
			<td><input type="password" name="passwd" dojoType="dijit.form.ValidationTextBox" value="$pwd"
                        required="true" promptMessage="Captura contrase&ntilde;a de usuario."
                        invalidMessage="La contrase&ntilde;a de usuario es requerida." trim="true" />
			</td>
		</tr>
                <tr>
                    <td width="200px" align="right"><label for="usrFirstName">Nombre(s) <em>*</em></label></td>
                    <td><input name="firstName" value="$firstName" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="Captura Nombre(s)" invalidMessage="Nombre(s) es requerido" style="width:300px;"  trim="true"/></td>
                </tr>
                <tr>
                    <td width="200px" align="right"><label for="usrLastName">Primer Apellido <em>*</em></label></td>
                    <td><input name="lastName" value="$lastName" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="Captura Primer Apellido" invalidMessage="Primer Apellido es requerido" style="width:300px;"  trim="true"/></td>
                </tr>
                <tr>
                    <td width="200px" align="right"><label for="usrSecondLastName">Segundo Apellido &nbsp;</label></td>
                    <td><input name="secondLastName" value="$secondLastName" dojoType="dijit.form.ValidationTextBox" required="false" promptMessage="Captura Segundo Apellido" invalidMessage="Dato Invalido" style="width:300px;"  trim="true"/></td>
                </tr>
                <tr>
                    <td width="200px" align="right"><label for="usrEmail">Correo Electr&oacute;nico<em>*</em></label></td>
                    <td><input name="email" dojoType="dijit.form.ValidationTextBox" required="true" promptMessage="Captura Correo Electr&oacute;nico" 
                        invalidMessage="El correo electr&oacute;nico de usuario es invalido o ya existe."
                        isValid="return canAddEmail('$repository',this.textbox.value);"
                        style="width:300px;"  value="$email" trim="true"/></td>
                </tr>


                <tr><td colspan="2" align="center">&nbsp;</td></tr>
                <tr><td colspan="2" align="center">&nbsp;</td></tr>

                <tr><td colspan="2" align="center">
                <img src="$context/swbadmin/jsp/securecode.jsp?sAttr=cdlog" id="imgseccode" width="155" height="65" /><br/>
                <a href="#" onclick="changeSecureCodeImage('imgseccode');">Cambiar imagen</a><br/>
                </td></tr>
                <tr><td width="200px" align="right">
                <label for="cmnt_seccode">El texto de la imagen es:</label></td>
                <td><input type="text" id="cmnt_seccode" name="cmnt_seccode" size="45" /></td>
                </tr>

	<tr>
		<td align="center" colspan="2">
                    
<script type="text/javascript">

 function enviar(){
    var x=document.getElementById('org.semanticwb.community.User/com/create');
    var objd=dijit.byId('org.semanticwb.community.User/com/create');
    if (objd.isValid())
    {
        if(isEmpty('cmnt_seccode')) {
            alert('Para poder agregar tu comentario es necesario que ingreses el código de la imagen.\\nEn caso de no ser claro puedes cambiarlo haciendo clic en <<Cambiar imagen>>.');
        }else{
            x.submit();
        }
    } else {
        alert("Datos incompletos o erroneos");
    }

 }

   function changeSecureCodeImage(imgid) {
     var img = dojo.byId(imgid);
     if(img) {
        var rn = Math.floor(Math.random()*99999);
        img.src = "$context/swbadmin/jsp/securecode.jsp?sAttr=cdlog&nc="+rn;
     }
   }

    function isEmpty(objid) {
        var obj = dojo.byId(objid);
        if (obj==null || obj.value=='' || !isNaN(obj.value) || obj.value.charAt(0) == ' ') {
            return true;
        }else {
            return false;
        }
    }
/*
    function enviar()
    {
        var x=document.getElementById('org.semanticwb.community.User/com/create');        
        if(!x.login.value)
        {
            alert('El identificador de usuario es requerido.');
            x.login.focus();
            return;
        }
        if(!x.passwd.value)
        {
            alert('La contraseña de usuario es requerido.');
            x.passwd.focus();
            return;
        }
        x.submit();
    }
*/
</script>

			</td>
		</tr>
	</table>
	</fieldset>
</form>"""
