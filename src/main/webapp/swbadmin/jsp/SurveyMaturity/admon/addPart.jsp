<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.questionnaire.Part"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
            SWBResourceURL urlAction = paramRequest.getActionUrl();
            urlAction.setCallMethod(SWBResourceURL.Call_DIRECT);
            urlAction.setAction("addPart");
            WebSite site = paramRequest.getWebPage().getWebSite();

            String id = request.getParameter("id");
            Part part = null;
            if (id != null)
            {
                part = Part.ClassMgr.getPart(id, site);
            }
%>
<script type="text/javascript">
    function closeDialogAddPart()
    {
        
        dijit.byId("dialogAdmonParte").hide();
    }
    function saveDialogAddPart(forma)
    {
        saveAndContinueDialogAddPart(forma);
        dijit.byId("dialogAdmonParte").hide();
        
    }
    function saveAndContinueDialogAddPart(forma)
    {
        try
        {

            var namepart=forma.namepart.value;
            if(!namepart)
            {
                alert('Indique el nombre de la parte del cuestionario');
                forma.namepart.focus();
                return;
            }


            var tituloparteditor=getValueEditor('tituloparteditor');
            if(tituloparteditor.isEmpty())
            {
                alert('Indique el título de la parte del cuestionario');
                dijit.byId('tituloparteditor').focus();
                return;
            }
            var descriptionparteditor=getValueEditor('descriptionparteditor');
            if(descriptionparteditor.isEmpty())
            {
                alert('Indique la descripción de la parte del cuestionario');
                dijit.byId('descriptionparteditor').focus();
                return;
            }
            forma.tituloparte.value=tituloparteditor;
            forma.descriptionparte.value=descriptionparteditor;
            sendform(forma.id,reloadAdmonParte);
            forma.tituloparte.value='';
            forma.descriptionparte.value='';
            forma.namepart.value='';
            resetEditor('tituloparteditor');
            resetEditor('descriptionparteditor');


        }
        catch(err)
        {
            alert(err.message);
        }
    }
   
</script>
<h1 align="center">Parte</h1><br>
<form id="frmAddPart" action="<%=urlAction%>">
    <%
                if (part != null)
                {
                    String partid = part.getId();
    %>

    <input type="hidden" name="part" value="<%=partid%>">
    <%
                }
    %>

    <input type="hidden" name="tituloparte">
    <input type="hidden" name="descriptionparte">
    <table>
        <tr>
            <td>
                Nombre:
            </td>
            <td>
                <%
                            String nombre = "";
                            if (part != null && part.getNamePart() != null)
                            {
                                nombre = part.getNamePart();
                            }
                %>
                <input type="text" maxlength="80" size="80" name="namepart" value="<%=nombre%>">
            </td>
        </tr>
        <tr>
            <td>
                T&iacute;tulo:
            </td>
            <td>
                <%
                            String tituloparteditor = "";
                            if (part != null && part.getTitle() != null)
                            {
                                tituloparteditor = part.getTitle();
                            }
                %>
                <div dojoType="dijit.Editor" id="tituloparteditor">
                    <%=tituloparteditor%>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                &nbsp;
            </td>

        </tr>
        <tr>
            <td>
                Descripci&oacute;n:
            </td>
            <td>
                <%
                            String descriptionparteditor = "";
                            if (part != null && part.getDescription() != null)
                            {
                                descriptionparteditor = part.getDescription();
                            }
                %>
                <div dojoType="dijit.Editor" id="descriptionparteditor">
                    <%=descriptionparteditor%>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="right">
                <input type="button" value="Cancelar" onclick="closeDialogAddPart();">&nbsp;<input type="button" value="Guardar" onclick="saveDialogAddPart(this.form)">&nbsp;<input type="button" value="Guardar y Agregar" onclick="saveAndContinueDialogAddPart(this.form);">
            </td>

        </tr>
    </table>
</form>
