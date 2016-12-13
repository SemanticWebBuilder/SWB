<%@page import="org.semanticwb.questionnaire.Section"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();
    urlAction.setCallMethod(SWBResourceURL.Call_DIRECT);
    urlAction.setAction("addSection");

    WebSite site = paramRequest.getWebPage().getWebSite();

    String id = request.getParameter("id");
    Section section = null;
    if (id != null) {
        section = Section.ClassMgr.getSection(id, site);
    }
%>
<script type="text/javascript">
    function closeDialogAddSection()
    {
        dijit.byId("dialogAdmonSection").hide();
    }

     function saveDialogAddSection(forma)
    {
        try
        {                                       
            var titulosectioneditor=getValueEditor('titulosectioneditor');
            if(titulosectioneditor.isEmpty()){
                alert('Indique el titulo de la seccion');
                dijit.byId('titulosectioneditor').focus();
                return;
            }            
            var descriptionsectioneditor=getValueEditor('descriptionsectioneditor');
            if(titulosectioneditor.isEmpty()){
                alert('Indique el titulo de la seccion');
                dijit.byId('descriptionsectioneditor').focus();
                return;
            }  
            
            forma.titulosection.value=titulosectioneditor;
            forma.descripcionsection.value=descriptionsectioneditor;
            sendform(forma.id,reloadAdmonSection);
            forma.titulosection.value='';
            forma.descripcionsection.value='';
        
        }
        catch(err)
        {
            alert(err.message);
        }
        dijit.byId("dialogAdmonSection").hide();
    }
    
</script>

<div class="swbform"  region="center" id="faddSection">
<form id="frmAddSection" action="<%=urlAction%>">
    <fieldset>
        <legend>Secci&oacute;n</legend>
         <%
                if (section != null) {
                    String partid = section.getId();
            %>
             <input type="hidden" name="section" value="<%=partid%>">
            <%
                }
            %>      
        <input type="hidden" name="titulosection">
        <input type="hidden" name="descripcionsection">
    <table>
        <tr>
            <td>
                T&iacute;tulo:
            </td>
            <td>
                 <%
                            String titulosectionteditor = "";
                            if (section != null && section.getTitle() != null) {
                                titulosectionteditor = section.getTitle();
                            }
                        %>
                <div dojoType="dijit.Editor" id="titulosectioneditor">
                    <%=titulosectionteditor%>
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
                            String descriptionsectionditor = "";
                            if (section != null && section.getDescription() != null) {
                                descriptionsectionditor = section.getDescription();
                            }
                        %>
                <div dojoType="dijit.Editor" id="descriptionsectioneditor">
                    <%=descriptionsectionditor%>
                </div>
            </td>
        </tr>
    </table>
</fieldset>

        <fieldset>
            <ul class="swbform-ul">
                <li align="right" >
                    <input type="button" value="Cancelar" onclick="closeDialogAddSection();">&nbsp;<input type="button" value="Guardar" onclick="saveDialogAddSection(this.form)">
                </li>
            </ul>
        </fieldset>
    </form>
</div>
                