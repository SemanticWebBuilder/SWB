
<%@page import="org.semanticwb.survey.Admin"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.questionnaire.Part"%>
<%@page import="org.semanticwb.model.WebSite"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%!
    public String encode(String text)
    {
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
            urlRender.setMode(Admin.MODE_ADMON_ADD_PART);
            urlRender.setCallMethod(SWBResourceURL.Call_DIRECT);

%>

<script type="text/javascript">
    function showAdmonParte()
    {
        var url='<%=urlRender%>';
        reload(url, 'dialogAdmonParte',beforeshow);        
    }

    function deletePart(url,name)
    {

        if(confirm('¿Desea borrar la parte con nombre: '+name+'?'))
        {
            doGet(url, reloadAdmonParte);
        }
        
    }
    function beforeshow()
    {
        try
        {
            
            dijit.byId("dialogAdmonParte").show();
            
        }
        catch(err){alert('Error cargando dialogo'+err.message);}
    }
    function showEditPart(id)
    {
        var url='<%=urlRender%>'+'?id='+id;
        reload(url, 'dialogAdmonParte',beforeshow);
    }
</script>

<h1>Administraci&oacute;n de partes de un cuestionario</h1><br>
<input type="button" value="Agregar Parte" onclick="showAdmonParte();"><br><br>
<table width="100%" cellpadding="2" cellspacing="2" border="1">
    <th>Parte</th>
    <th>Acci&oacute;n</th>    
    <%
                SWBResourceURL urlAction = paramRequest.getActionUrl();
                WebSite site = paramRequest.getWebPage().getWebSite();
                Iterator<Part> parts = Part.ClassMgr.listParts(site);
                //String imageEdit="/swbadmin/jsp/SurveyMaturity/images/edit.png";
                String imageEdit = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/edit.png";
                //String imageDelete="/swbadmin/jsp/SurveyMaturity/images/delete.png";
                String imageDelete = "/work/sites/" + site.getId() + "/jsp/SurveyMaturity/images/delete.png";

                while (parts.hasNext())
                {
                    Part part = parts.next();
                    String name = part.getNamePart();
                    if (name == null)
                    {
                        name = "";
                    }
                    name = encode(name);
                    String id = part.getId();
                    String uri = part.getURI();
                    urlAction.setParameter("uri", uri);
                    urlAction.setAction("removePart");
                    urlAction.setWindowState(urlAction.WinState_NORMAL);
                    urlAction.setCallMethod(urlAction.Call_DIRECT);


    %>
    <tr>
        <td>
            <p><%=name%></p>
        </td>
        <td style="text-align: center;" class="tban-tarea">
            <a href="#" title="Editar" onclick="showEditPart('<%=id%>');"><img alt="editar"  src="<%=imageEdit%>"></a>
            <a href="#" title="Eliminar" onclick="deletePart('<%=urlAction%>','<%=name%>');"><img alt="eliminar"  src="<%=imageDelete%>"></a>
        </td>
    </tr>
    <%

                }
    %>

    <tr>
        <td colspan="2">
            &nbsp;
        </td>
    </tr>    
</table>


