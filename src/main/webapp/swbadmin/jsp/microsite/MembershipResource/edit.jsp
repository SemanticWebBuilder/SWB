<%-- 
    Document   : edit
    Created on : 3/09/2009, 12:24:30 PM
    Author     : juan.fernandez
--%>
<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebPage wpage=paramRequest.getWebPage();

    MicroSite site=MicroSite.getMicroSite(paramRequest.getWebPage());

    SWBResourceURL url_chk = paramRequest.getRenderUrl();
    url_chk.setMode(SWBResourceURL.Mode_HELP);
    url_chk.setCallMethod(SWBResourceURL.Call_DIRECT);

%>
<script type="text/javascript" src="/swbadmin/js/upload.js"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/swbadmin/css/upload/upload.css"/>
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
    			//pb.parentNode.style.display='none';
    		},
    		onFailure: function(msg) {
    			pb.parentNode.style.display='none';
    			alert(msg);
    			uploads_in_progress = uploads_in_progress - 1;
    		},
            url: '<%=url_chk%>'
    	});
    }
</script>
<script type="text/javascript">
           //dojo.require("dojo.parser");
           dojo.require("dijit.form.Form");
           //dojo.require("dojox.layout.ContentPane");
           //dojo.require("dijit.form.ValidationTextBox");
           //dojo.require("dijit.form.Button");
           //dojo.require("dijit.Dialog");
           //dojo.require("dijit.form.FilteringSelect");
           //dojo.require("dijit.form.Textarea");

 function enviar(){
    var x=document.getElementById("fupload");
    x.submit();
 }
 </script>
<%
SWBResourceURL urla = paramRequest.getActionUrl();
urla.setParameter("act", "upload");
urla.setCallMethod(SWBResourceURL.Call_DIRECT);

String pathPhoto = "/swbadmin/jsp/microsite/MembershipResource/userIMG.jpg";
String path = wpage.getWorkPath();
String backURL=wpage.getUrl();
if(site.getPhoto()!=null)
{
    pathPhoto =SWBPortal.getWebWorkPath() + path+"/"+site.getPhoto();
}
%>
<div class="columnaIzquierda">
<p><img src="<%=pathPhoto%>" alt="Imagen comunidad" /></p>

<div id="clear">&nbsp;</div>

<form id="fupload" name="fupload" enctype="multipart/form-data" class="swbform" dojoType="dijit.form.Form" action="<%=urla%>" method="post" target="pictureTransferFrame" >
    <fieldset>
        <legend>Imagen comunidad</legend>
        <table>
            <tr><td width="200px" align="right"><label for="picture">Im&aacute;gen &nbsp;</label></td>
                <td><iframe id="pictureTransferFrame" name="pictureTransferFrame" src="" style="display:none" ></iframe>
                    <input type="file" name="picture" onchange="beginAsyncUpload(this,'picture');" />
                    <br/><div style="width:200px; height: 2px; border: 0px solid #BBB; text-align: center; float: left;"><div id="picture_progress" style=" height: 1px; position: relative; margin: 0px; padding: 1px; background: #9DC0F4; width: 0; float: left;" ></div></div>
                </td></tr>
            <tr><td colspan="2" align="center"><br/><br/>
                                    <br/>
                                <div class="editarInfo">
                                <p><a href="javascript:enviar();">[Cambiar imagen]</a></p>
                                </div>
                                <div class="editarInfo">
                                <p><a href="<%=backURL%>">[Cancelar]</a></p>
                                </div>
                                </td></tr>
	</table>
        </fieldset>
</form>
</div>
    <div class="columnaCentro"></div>



