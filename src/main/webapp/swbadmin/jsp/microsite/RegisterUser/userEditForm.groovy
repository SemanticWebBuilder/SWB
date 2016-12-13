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
import org.semanticwb.SWBPlatform
import org.semanticwb.SWBPortal
import org.semanticwb.model.WebPage
import org.semanticwb.model.DisplayProperty
import org.semanticwb.portal.api.SWBResourceURL
import org.semanticwb.platform.SemanticProperty
import org.semanticwb.platform.SemanticObject
import org.semanticwb.portal.SWBFormMgr

def paramRequest=request.getAttribute("paramRequest")
User user = paramRequest.getUser()
WebPage wpage=paramRequest.getWebPage()
def mapa = new HashMap()
Iterator<SemanticProperty> list = org.semanticwb.SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass("http://www.semanticwebbuilder.org/swb4/community#_ExtendedAttributes").listProperties();
                list.each{
                    def sp = it
                    System.out.println("prop:"+sp.getName())
                    mapa.put(sp.getName(),sp)
                }


def uri = ""
try {uri = user.getEncodedURI()} catch (Exception e) {}
def acc_url = paramRequest.getActionUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setAction("edit")
def url_chk = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode(SWBResourceURL.Mode_HELP)
def url_actPic = paramRequest.getActionUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setAction("upload")
def url_actFB = paramRequest.getActionUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setAction("actFB").setMode(SWBResourceURL.Mode_EDIT)
def id = user.getId()
def usr_name = (user.getFirstName()==null?"":user.getFirstName())
def usr_lname = (user.getLastName()==null?"":user.getLastName())
def usr_sname = (user.getSecondLastName()==null?"":user.getSecondLastName())
def usr_mail = (user.getEmail()==null?"":user.getEmail())
def usr_login = user.getLogin()
def usr_age = user.getExtendedAttribute(mapa.get("userBirthDate"))
if (null==usr_age) usr_age = ""
def usr_sex = user.getExtendedAttribute(mapa.get("userSex"))
def usr_sexM = ""
def usr_sexF = ""
if ("M".equals(usr_sex)) usr_sexM = "selected=\"selected\""
if ("F".equals(usr_sex)) usr_sexF = "selected=\"selected\""
def usr_status = user.getExtendedAttribute(mapa.get("userStatus"))
if (null==usr_status) usr_status = ""
def usr_interest = user.getExtendedAttribute(mapa.get("userInterest"))
if (null==usr_interest) usr_interest = ""
def usr_hobbies = user.getExtendedAttribute(mapa.get("userHobbies"))
if (null==usr_hobbies) usr_hobbies = ""
def usr_inciso = user.getExtendedAttribute(mapa.get("userInciso"))
if (null==usr_inciso) usr_inciso = ""

def latitude = user.getExtendedAttribute(mapa.get("latitude"))
System.out.println("userLAt:"+latitude)
if (null==latitude) latitude = "22.99885"
def longitude = user.getExtendedAttribute(mapa.get("longitude"))
if (null==longitude) longitude = "-101.77734"
def geoStep = user.getExtendedAttribute(mapa.get("geoStep"))
if (null==geoStep) geoStep = "4"

def key = SWBPortal.getEnv("key/gmap","")

def usr_doings = user.getExtendedAttribute(mapa.get("userDoings"))
if (null==usr_doings) usr_doings = ""
SemanticObject sobj=mapa.get("userDoings").getDisplayProperty()
DisplayProperty dobj=new DisplayProperty(sobj);
def selectValues=dobj.getDisplaySelectValues("es");
def usr_do_sel = ""
StringTokenizer st=new StringTokenizer(selectValues,"|");
                while(st.hasMoreTokens())
                {
                    String tok=st.nextToken();
                    int ind=tok.indexOf(':');
                    String vid=tok;
                    String val=tok;
                    if(ind>0)
                    {
                        vid=tok.substring(0,ind);
                        val=tok.substring(ind+1);
                    }
                    usr_do_sel = usr_do_sel + "<option value=\""+vid+"\" "
                    if(vid.equals(usr_doings))
                        usr_do_sel = usr_do_sel + "selected"
                    usr_do_sel = usr_do_sel + ">"+val+"</option>\n"
                }
                

def fb_app_key = "691414c29ca930cc6961213e3c5d34c7"
//User.sclass
SWBFormMgr frm = new SWBFormMgr(user.getSemanticObject(), null, SWBFormMgr.MODE_EDIT)
frm.setLang("es")
frm.setType(SWBFormMgr.TYPE_DOJO)


println """
<script language="javascript" type="text/javascript" src="/swbadmin/js/upload.js"></script>

	<style type="text/css">
 @import "/swbadmin/css/upload.css";
import org.semanticwb.platform.SemanticObject
import org.semanticwb.platform.SemanticObject
import org.semanticwb.platform.SemanticObject
import org.semanticwb.model.DisplayProperty
 </style>
    <script type="text/javascript">
    var uploads_in_progress = 0;

    function beginAsyncUpload(ul,sid) {
      ul.form.submit();
    	uploads_in_progress = uploads_in_progress + 1;
    	var pb = document.getElementById(ul.name + "_progress");
    	pb.parentNode.style.display='block';
    	new ProgressTracker(sid,{
    		progressBar: pb,
    		onComplete: function() {
    			var inp_id = pb.id.replace("_progress","");
    			uploads_in_progress = uploads_in_progress - 1;
    			var inp = document.getElementById(inp_id);
    			if(inp) {
    				inp.value = sid;
    			}
    			pb.parentNode.style.display='none';
    		},
    		onFailure: function(msg) {
    			pb.parentNode.style.display='none';
    			alert(msg);
    			uploads_in_progress = uploads_in_progress - 1;
    		},
            url: '$url_chk'
    	});
    }

	</script>
<script type="text/javascript">
           dojo.require("dojo.parser");
                   dojo.require("dijit.form.Form");
                   dojo.require("dojox.layout.ContentPane");
                   dojo.require("dijit.form.ValidationTextBox");
                   dojo.require("dijit.form.Button");
                   dojo.require("dijit.Dialog");
                   dojo.require("dijit.form.FilteringSelect");
                   dojo.require("dijit.form.Textarea");

 function enviar(){
    var x=document.getElementById(\"form_$id\");
    var objd=dijit.byId(\"form_$id\");
    if (objd.isValid())
    {
        x.submit();
    } else {
        alert("Datos incompletos o erroneos");
    }

 }
        </script>
<form id="form_$id" dojoType="dijit.form.Form" class="swbform"
action="$acc_url"   method="post">
<div class="adminTools">
                    <p><a  class="adminTool"href="javascript:enviar()">Guardar</a>&nbsp;&nbsp;&nbsp;&nbsp;<a  class="adminTool"href="javascript:history.back();">Cancelar</a></p>
                    </div>
    <input type="hidden" name="suri" value="$uri"/>
    <input type="hidden" name="scls" value="http://www.semanticwebbuilder.org/swb4/ontology#User"/>
    <input type="hidden" name="smode" value="edit"/>
    <fieldset>
    <legend>Datos Personales</legend>
        <table>
            <tr><td width="200px" align="right">Identificador &nbsp;</td>
                <td>$usr_login</td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, User.swb_usrFirstName, SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, User.swb_usrFirstName, SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, User.swb_usrLastName, SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, User.swb_usrLastName, SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, User.swb_usrSecondLastName, SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, User.swb_usrSecondLastName, SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, User.swb_usrEmail, SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, User.swb_usrEmail, SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right"><label for="usrPassword">Contrase&ntilde;a &nbsp;</label></td>
                <td><input name="usrPassword" type="password"  dojoType="dijit.form.ValidationTextBox"
                required="false" promptMessage="Captura Contraseña." invalidMessage=""
                trim="true" value="{MD5}tq5RXfs6DGIXD6dlHUgeQA==">
            </td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, (SemanticProperty)mapa.get("userBirthDate"), SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, (SemanticProperty)mapa.get("userBirthDate"), SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, (SemanticProperty)mapa.get("userSex"), SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, (SemanticProperty)mapa.get("userSex"), SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right">${frm.renderLabel(request, (SemanticProperty)mapa.get("userDoings"), SWBFormMgr.MODE_EDIT)}</td>
                    <td>${frm.renderElement(request, (SemanticProperty)mapa.get("userDoings"), SWBFormMgr.MODE_EDIT)}</td></tr>
        </table>
    </fieldset>
    <fieldset>
    <legend>Informaci&oacute;n complementaria</legend>
	<table>
            <tr><td width="200px" align="right">${frm.renderLabel(request, (SemanticProperty)mapa.get("userStatus"), SWBFormMgr.MODE_EDIT)}</td>
                <td>${frm.renderElement(request, (SemanticProperty)mapa.get("userStatus"), SWBFormMgr.MODE_EDIT)}</td></tr>
            <tr><td width="200px" align="right">Intereses &nbsp;</td>
                <td><textarea name="userInterest" rows="10" cols="50" dojoType="dijit.form.Textarea">$usr_interest</textarea></td></tr>
            <tr><td width="200px" align="right">Pasatiempos &nbsp;</td>
                <td><textarea name="userHobbies" rows="10" cols="50" dojoType="dijit.form.Textarea">$usr_hobbies</textarea></td></tr>
            <tr><td width="200px" align="right">Ubicaci&oacute;n &nbsp;</td>
                <td>

<input type="text" size="60" id ="gmap_address" value="Introduce Calle, Colonia y Estado" onKeyPress="if (event.which==13) {search(); return false;} "/>
<button onclick="search(); return false;"> buscar </button>
<input type="hidden" id="latitude" name="latitude" value="$latitude"/>
<input type="hidden" id="longitude" name="longitude" value="$longitude"/>
<input type="hidden" id="geoStep" name="geoStep" value="$geoStep"/>
<div id="map_canvas" style="width: 500px; height: 300px"></div>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=$key"
      type="text/javascript"></script>

<script type="text/javascript" language="javascript">

function initialize() {
    if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map_canvas"));
        map.addControl(new GSmallMapControl());
        map.addControl(new GMapTypeControl());
        var center = new GLatLng($latitude, $longitude);
        geocoder = new GClientGeocoder();
        setUpMap(map, center, $geoStep);
    }
}

function setUpMap(map, center, step){
    map.setCenter(center, step);
    var marker = new GMarker(center, {draggable: true});
    map.addOverlay(marker);
    GEvent.addListener(marker, "dragend", function() {
        var point = marker.getPoint();
        map.panTo(point);
        document.getElementById("latitude").value = center.lat().toFixed(7);
        document.getElementById("longitude").value = center.lng().toFixed(7);
        document.getElementById("geoStep").value = map.getZoom();
    });
    GEvent.addListener(map, "moveend", function() {
        map.clearOverlays();
        var center = map.getCenter();
        var marker = new GMarker(center, {draggable: true});
        map.addOverlay(marker);
        document.getElementById("latitude").value = center.lat().toFixed(7);
        document.getElementById("longitude").value = center.lng().toFixed(7);
        document.getElementById("geoStep").value = map.getZoom();
        GEvent.addListener(marker, "dragend", function() {
            var point = marker.getPoint();
            map.panTo(point);
            document.getElementById("latitude").value = center.lat().toFixed(7);
            document.getElementById("longitude").value = center.lng().toFixed(7);
            document.getElementById("geoStep").value = map.getZoom();
    });
    });
}

function search() {
    var address = document.getElementById("gmap_address").value;
    var map = new GMap2(document.getElementById("map_canvas"));
    map.addControl(new GSmallMapControl());
    map.addControl(new GMapTypeControl());
    if (geocoder) {
        geocoder.getLatLng(
            address,
            function(point) {
                if (!point) {
                    alert(address + " no encontrada");
                } else {
                    document.getElementById("latitude").value = point.lat().toFixed(7);
                    document.getElementById("longitude").value = point.lng().toFixed(7);
                    document.getElementById("geoStep").value = 14;
                    map.clearOverlays();
                    setUpMap(map, point, 14);
                }
            });
    }
}
initialize();
    </script>

                </td></tr>
        </table>
    </fieldset>
</form>
<form id="fupload" name="fupload" enctype="multipart/form-data" class="swbform" dojoType="dijit.form.Form"
    action="$url_actPic"
    method="post" target="pictureTransferFrame" >
    <fieldset>
    <legend>Fotograf&iacute;a</legend>
        <table>
            <tr><td width="200px" align="right"><label for="picture">Fotograf&iacute;a &nbsp;</label></td>
                <td><iframe id="pictureTransferFrame" name="pictureTransferFrame" src="" style="display:none" ></iframe>
                    <input type="file" name="picture"
                        onchange="beginAsyncUpload(this,'picture');" />
                   <div class="progresscontainer" style="display: none;"><div class="progressbar" id="picture_progress"></div></div>
                </td></tr>
	</table>
    </fieldset>
</form>

"""
System.out.println "value: "+user.getSemanticObject().getProperty(User.swb_usrFirstName)
System.out.println User.swb_usrFirstName
System.out.println "---------"
System.out.println frm.renderLabel(request, User.swb_usrFirstName, SWBFormMgr.MODE_EDIT)
System.out.println frm.renderElement(request, User.swb_usrFirstName, SWBFormMgr.MODE_EDIT)

//System.out.println "*********************** User: ${user.getExternalID()} ${user.getLogin()}"
if (user.getExternalID()==null){
println """
<div xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php" type="text/javascript"></script>

<script type="text/javascript">
var name_user ;
function onConnected(sess){

    var api = FB.Facebook.apiClient;
    var idFB = api.get_session().uid;
    var keyFB = api.get_session().session_key;
    var secretFB  =api.get_session().secret;
    var sigFB  =api.get_session().sig;
    api.users_getInfo(idFB,'last_name, first_name',function(test)
{ 
    name_user =  (test[0].first_name+" "+test[0].last_name);
    sess = idFB;
    var answer = confirm ("Deseas ligar tu cuenta $usr_login al usuario "+sess+":"+name_user+"?");
    if (answer) {
    var x=document.getElementById('fbaddid');
    x.action="$url_actFB";
    var s=document.getElementById('fb_sess');
    s.value=idFB;
    var s=document.getElementById('fb_key');
    s.value=keyFB;
    var s=document.getElementById('fb_secret');
    s.value=secretFB;
    var s=document.getElementById('fb_sig');
    s.value=sigFB;
    x.submit();
}
}) ;
           

}
    FB.init("$fb_app_key", "/login" , {"ifUserConnected":onConnected, "doNotUseCachedConnectState":true});
</script><form id="fbaddid" name="fbaddid" method="post" action="" target="pictureTransferFrame"><input type="hidden" id="fb_sess" name="fb_sess">
<input type="hidden" id="fb_key" name="fb_key"><input type="hidden" id="fb_secret" name="fb_secret">
<input type="hidden" id="fb_sig" name="fb_sig"></form>
</div>
"""
}
