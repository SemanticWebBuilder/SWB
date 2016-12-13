<%@page import="org.semanticwb.survey.Admin"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%@page import="org.semanticwb.questionnaire.Section"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%!
    public String encode(String text) {
        text = text.replace("á", "&aacute;");
        text = text.replace("é", "&eacute;");
        text = text.replace("í", "&iacute;");
        text = text.replace("ó", "&oacute;");
        text = text.replace("ú", "&uacute;");
        text = text.replace("Á", "&Aacute;");
        text = text.replace("É", "&Eacute;");
        text = text.replace("Í", "&Iacute;");
        text = text.replace("Ó", "&Oacute;");
        text = text.replace("Ú", "&Uacute;");

        return text;
    }
%>
<%
    SWBResourceURL urlRender = paramRequest.getRenderUrl();
    urlRender.setMode(Admin.MODE_ADMON_ADD_SECTION);
    urlRender.setCallMethod(SWBResourceURL.Call_DIRECT);
%> 


<script type="text/javascript">
    function showAdmonSection()
    {
        var url='<%=urlRender%>';
        reloadLo(url, 'dialogAdmonSection',beforeshowSection); 
        
    }

        function deleteSection(url)
    {
          if(confirm('¿Desea borrar la seccion ?'))
        {
            doGet(url, reloadAdmonSection);
        }
    }
        function beforeshowSection()
    {
        try
        {
            
            dijit.byId("dialogAdmonSection").show();
            
        }
        catch(err){alert('Error cargando dialogo'+err.message);}
    }
    
        function showEditSection(id)
    {
        var url='<%=urlRender%>'+'?id='+id;
        reloadLo(url, 'dialogAdmonSection',beforeshowSection);        
    }


</script>
<div class="swbform"  region="center" id="fadmonSection">
<fieldset>
    <legend>Administraci&oacute;n de secciones de un cuestionario</legend>
   <table width="100%">
    <th>Secciones</th>
    <th>Acciones</th>

  <%
                SWBResourceURL urlAction = paramRequest.getActionUrl();
                WebSite site = paramRequest.getWebPage().getWebSite();
                Iterator<Section> section = Section.ClassMgr.listSections(site);
                String imageEdit = "/swbadmin/jsp/SurveyMaturity/images/edit.png";
                //String imageEdit = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/edit.png";
                String imageDelete = "/swbadmin/jsp/SurveyMaturity/images/delete.png";
                //String imageDelete = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/delete.png";

                while (section.hasNext()) {
                    Section s = section.next();
                    String name = s.getTitle();
                    if (name == null) {
                        name = "";
                    }
                    name = encode(name);
                    String id = s.getId();
                    String uri = s.getURI();
                    urlAction.setParameter("uri", uri);
                    urlAction.setAction("removeSection");
                    urlAction.setWindowState(urlAction.WinState_NORMAL);
                    urlAction.setCallMethod(urlAction.Call_DIRECT);


            %>
    <tr>
        <td>
                          <%=name%>
        </td>
        <td>
                 <a href="#" title="Editar" onclick="showEditSection('<%=id%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/edit.png"></a>
                 <a href="#" title="Eliminar" onclick="deleteSection('<%=urlAction%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>
        </td>
    </tr>
         <%
          }
        %>
</table>
</fieldset>

<fieldset>
    <ul class="swbform-ul">
        <li align="right" >
             <input type="button" value="Agregar Secci&oacute;n" onclick="showAdmonSection();">
        </li>
    </ul>
</fieldset>
</div>


