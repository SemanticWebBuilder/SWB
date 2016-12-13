<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.survey.Admin"%>
<%@page import="org.semanticwb.questionnaire.BankInstitution"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
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
<!DOCTYPE html>
<%
    SWBResourceURL urlRender = paramRequest.getRenderUrl();
    urlRender.setMode(Admin.MODE_ADMON_ADD_INSTITUTION);
    urlRender.setCallMethod(SWBResourceURL.Call_DIRECT);

%>

<script type="text/javascript">
    function showAddInstitution()
    {
        var url='<%=urlRender%>';
        reloadLo(url, 'dialogaddInstitution',beforeshowInstitution);  
    }
    
        function beforeshowInstitution()
    {
        try
        {
            
            dijit.byId("dialogaddInstitution").show();
            
        }
        catch(err){alert('Error cargando dialogo'+err.message);}
    }

    function deleteInstitution(url,name)
    {
         
         if(confirm('¿Desea borrar la Institucion con nombre:'+name+' ?'))
        {
            doGet(url, reloadAdmonInstitution);
        }
          
    }
    function showEditInstitution(id){
        var url='<%=urlRender%>'+'?id='+id;
        reloadLo(url, 'dialogaddInstitution',beforeshowInstitution);
        
    }



</script>

<div class="swbform"  region="center" id="fadmonInstitution">
<fieldset>
    <legend>Administraci&oacute;n de Instituciones</legend>
    <table width="100%" >
        <th>Instituciones</th>
        <th>Acciones</th>

 <%
                SWBResourceURL urlAction = paramRequest.getActionUrl();
                WebSite site = paramRequest.getWebPage().getWebSite();
                Iterator<BankInstitution> institution = BankInstitution.ClassMgr.listBankInstitutions(site);
                String imageEdit = "/swbadmin/jsp/SurveyMaturity/images/edit.png";
                //String imageEdit = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/edit.png";
                String imageDelete = "/swbadmin/jsp/SurveyMaturity/images/delete.png";
                //String imageDelete = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/delete.png";

                while (institution.hasNext()) {
                    BankInstitution ins = institution.next();
                    String name = ins.getNameInstitution();
                    if (name == null) {
                        name = "";
                    }
                    name = encode(name);
                    String id = ins.getId();
                    String uri = ins.getURI();
                    urlAction.setParameter("uri", uri);
                    urlAction.setAction("removeInstitution");
                    urlAction.setWindowState(urlAction.WinState_NORMAL);
                    urlAction.setCallMethod(urlAction.Call_DIRECT);


            %>
        <tr>
            <td>
                 <%=name%>
            </td>
            <td style="text-align: center;" class="tban-tarea">
                 <a href="#" title="Editar" onclick="showEditInstitution('<%=id%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/edit.png"></a>
                 <a href="#" title="Eliminar" onclick="deleteInstitution('<%=urlAction%>','<%=name%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>
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
            <input type="button" value="Agregar Instituci&oacute;" onclick="showAddInstitution();">
        </li>
    </ul>
</fieldset>
</div>

