<%@page import="org.semanticwb.questionnaire.Questionnaire"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.questionnaire.Part"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();
    urlAction.setCallMethod(SWBResourceURL.Call_DIRECT);
    urlAction.setAction("addSurvey");
    WebSite site = paramRequest.getWebPage().getWebSite();

    String id = request.getParameter("id");
    Questionnaire survey = null;
    if (id != null) {
        survey = Questionnaire.ClassMgr.getQuestionnaire(id, site);
    }
%>


<script type="text/javascript">
    function closeDialogAddSurvey()
    {
        dijit.byId("dialogaddSurvey").hide();
    }
    function saveDialogaddSurvey(forma)
    {
        try
        {
            var titleSurvey=getValueEditor('titleSurvey');
            if(titleSurvey.isEmpty()){
                dijit.byId('titleSurvey').focus();
                alert('Indique un titulo para el cuestionario');
            }
            var presentationSurvey=getValueEditor('presentationSurvey');
            if(presentationSurvey.isEmpty()){
                alert('Indique un presentación para el cuestionario');
                 dijit.byId('presentationSurvey').focus();
                return;
            }
            var instructionsSurvey=getValueEditor('instructionsSurvey');
            if(instructionsSurvey.isEmpty()){
                alert('Indique las instrucciones para el cuestionario');
                dijit.byId('instructionsSurvey').focus();
                return;
            }
            forma.tituloSurvey.value=titleSurvey;
            forma.presentacion.value=presentationSurvey;
            forma.instrucciones.value=instructionsSurvey;
            sendform(forma.id,reloadAdmonSurvey);   
            
            forma.tituloSurvey.value='';
            forma.presentacion.value='';
            forma.instrucciones.value='';            
          
        }
        catch(err)
        {
            alert(err.message);
        }
          dijit.byId("dialogaddSurvey").hide();
    }
    

</script>
<%
            String pathLogo = "";
%>
<div class="swbform"  region="center" id="faddSurvey">
  <form id="frmAddSurvey"   action="<%=urlAction%>">
      <fieldset>
            <legend>Cuestionario</legend>
            
       <%
                if (survey != null) {
                    String surveyid = survey.getId();
            %>

            <input type="hidden" name="survey" value="<%=surveyid%>">
            <%
                }
       %>
            
    <input type="hidden" name="tituloSurvey">
    <input type="hidden" name="presentacion">
    <input type="hidden" name="instrucciones">
    <table>
        <tr>
            <td>
                <img alt="logo"  src="<%=pathLogo%>">
            </td>
            <td>
                <input type="file" name="logo">
            </td>
        </tr>
        <tr>
            <td colspan="2">
                &nbsp;
            </td>

        </tr>
        <tr>
            <td>
                T&iacute;tulo:
            </td>
            <td>
                <%
                            String titulo = "";
                            if (survey != null && survey.getTitle() != null) {
                                titulo = survey.getTitle();
                            }
                        %>
                <div dojoType="dijit.Editor" id="titleSurvey">
                    <%=titulo%>
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
                Presentaci&oacute;n:
            </td>
            <td>
                      <%
                            String pre = "";
                            if (survey != null && survey.getPresentation()!= null) {
                                pre = survey.getPresentation();
                            }
                        %>
                <div dojoType="dijit.Editor" id="presentationSurvey">
                    <%=pre%>
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
                Instrucciones de llenado:
            </td>
            <td>
                     <%
                            String inst = "";
                            if (survey != null && survey.getInstructions()!= null) {
                                inst = survey.getPresentation();
                            }
                        %>
                
               <div dojoType="dijit.Editor" id="instructionsSurvey">
                   <%=inst%>
               </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="right">
                <input type="button" value="Cancelar" onclick="closeDialogAddSurvey();">&nbsp;<input type="button" value="Guardar" onclick="saveDialogaddSurvey(this.form)">
            </td>
        </tr>
    </table>
</form>