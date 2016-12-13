<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.survey.Admin"%>
<%@page import="org.semanticwb.questionnaire.BankUnitsSubstantive"%>
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
    urlRender.setMode(Admin.MODE_ADMON_ADD_UNIT);
    urlRender.setCallMethod(SWBResourceURL.Call_DIRECT);

%>
<script type="text/javascript">
    function showAddUnit()
    {
        var url='<%=urlRender%>';
        reloadLo(url, 'dialogaddUnit',beforeshowUnit());  
    }


    function deleteUnit(url, name)
    {
          
        if(confirm('¿Desea borrar la Unidad Sustantiva con nombre: '+name+' ?'))
        {
            doGet(url, reloadAdmonUnit);
        }
          
    }
        function showEditUnit(id)
    {
        var url='<%=urlRender%>'+'?id='+id;
        reloadLo(url, 'dialogaddUnit',beforeshowUnit);
        
    }
    
        function beforeshowUnit()
    {
        try
        {
            
            dijit.byId("dialogaddUnit").show();
            
        }
        catch(err){alert('Error cargando dialogo'+err.message);}
    }



</script>

<div class="swbform"  region="center" id="workspace">
<fieldset>
    <legend>Administraci&oacute;n de Unidades Sustantivas</legend>
    <table width="100%" >
        <th>Unidades Sustantivas</th>
        <th>Acciones</th>

<%
                SWBResourceURL urlAction = paramRequest.getActionUrl();
                WebSite site = paramRequest.getWebPage().getWebSite();
                Iterator<BankUnitsSubstantive> units = BankUnitsSubstantive.ClassMgr.listBankUnitsSubstantives(site);
                String imageEdit = "/swbadmin/jsp/SurveyMaturity/images/edit.png";
                //String imageEdit = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/edit.png";
                String imageDelete = "/swbadmin/jsp/SurveyMaturity/images/delete.png";
                //String imageDelete = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/delete.png";

                while (units.hasNext()) {
                    BankUnitsSubstantive unit = units.next();
                    String name = unit.getNameUnitSubstantive();
                    if (name == null) {
                        name = "";
                    }
                    name = encode(name);
                    String id = unit.getId();
                    String uri = unit.getURI();
                    urlAction.setParameter("uri", uri);
                    urlAction.setAction("removeUnit");
                    urlAction.setWindowState(urlAction.WinState_NORMAL);
                    urlAction.setCallMethod(urlAction.Call_DIRECT);


            %>
        <tr>
            <td>
                 <%=name%>
            </td>
            <td style="text-align: center;" class="tban-tarea">
                 <a href="#" title="Editar" onclick="showEditUnit('<%=id%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/edit.png"></a>
                 <a href="#" title="Eliminar" onclick="deleteUnit('<%=urlAction%>','<%=name%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>
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
             <input type="button" value="Agregar Unidad Sustantiva" onclick="showAddUnit();">
        </li>
    </ul>
</fieldset>
</div>

