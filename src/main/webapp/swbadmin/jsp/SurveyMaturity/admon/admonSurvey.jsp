<%@page import="org.semanticwb.questionnaire.Questionnaire"%>
<%@page import="org.semanticwb.survey.Admin"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.questionnaire.Part"%>
<%@page import="org.semanticwb.model.WebSite"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
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
    urlRender.setMode(Admin.MODE_ADMON_ADD_SURVEY);
    urlRender.setCallMethod(SWBResourceURL.Call_DIRECT);

%>

<script type="text/javascript">
    function showAddSurvey()
    {
        var url='<%=urlRender%>';
        reloadLo(url, 'dialogaddSurvey',beforeshowSurvey);  
  
    }

    function beforeshowSurvey()
    {
        try
        {
            
            dijit.byId("dialogaddSurvey").show();
            
        }
        catch(err){alert('Error cargando dialogo'+err.message);}
    }

    function deleteSurvey(url)
    {
 
       if(confirm('¿Desea borrar el cuestionario ?'))
        {
            doGet(url, reloadAdmonSurvey);
        }
          
    }
      function showEditSurvey(id)
    {
        var url='<%=urlRender%>'+'?id='+id;
        reloadLo(url, 'dialogaddSurvey',beforeshowSurvey);
        
    }



</script>

<div class="swbform"  region="center" id="fadmonSurvey">
<fieldset>
    <legend>Administraci&oacute;n de Cuestionarios</legend>
    <table width="100%" >
        <th>Cuestionarios</th>
        <th>Acciones</th>

  <%
                SWBResourceURL urlAction = paramRequest.getActionUrl();
                WebSite site = paramRequest.getWebPage().getWebSite();
               
                Iterator<Questionnaire> survey = Questionnaire.ClassMgr.listQuestionnaires(site);
                String imageEdit = "/swbadmin/jsp/SurveyMaturity/images/edit.png";
                //String imageEdit = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/edit.png";
                String imageDelete = "/swbadmin/jsp/SurveyMaturity/images/delete.png";
                //String imageDelete = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/delete.png";

                while (survey.hasNext()) {
                    Questionnaire q = survey.next();
                    String name = q.getTitle();
                    if (name == null) {
                        name = "";
                    }
                    name = encode(name);
                    String id = q.getId();
                    String uri = q.getURI();
                    urlAction.setParameter("uri", uri);
                    urlAction.setAction("removeSurvey");
                    urlAction.setWindowState(urlAction.WinState_NORMAL);
                    urlAction.setCallMethod(urlAction.Call_DIRECT);


            %>
        <tr>
            <td>
                <%=name%>
            </td>
            <td style="text-align: center;" class="tban-tarea">
                 <a href="#" title="Editar" onclick="showEditSurvey('<%=id%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/edit.png"></a>
                 <a href="#" title="Eliminar" onclick="deleteSurvey('<%=urlAction%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>
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
             <input type="button" value="Agregar Cuestionario" onclick="showAddSurvey();">
        </li>
    </ul>
</fieldset>
</div>

