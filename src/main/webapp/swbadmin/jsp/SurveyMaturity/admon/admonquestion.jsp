

<%@page import="org.semanticwb.questionnaire.Question"%>
<%@page import="org.semanticwb.questionnaire.Section"%>
<%@page import="org.semanticwb.questionnaire.Part"%>
<%@page import="org.semanticwb.survey.Admin"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.questionnaire.Questionnaire"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            WebSite site = paramRequest.getWebPage().getWebSite();
            SWBResourceURL urlSelectpart = paramRequest.getRenderUrl();
            urlSelectpart.setCallMethod(SWBResourceURL.Call_DIRECT);
            urlSelectpart.setMode(Admin.MODE_ADMON_SHOW_QUESTIONS);
            urlSelectpart.setWindowState(SWBResourceURL.WinState_NORMAL);

%>
<script type="text/javascript">
    function showAddQuestion()
    {
        dijit.byId("dialogaddCuestion").show();
    }
    function changeDisplayQuestions(forma)
    {
        var id='showQuestions';
        var idQuestionarie=forma.cuestionario.value;
        var url='<%=urlSelectpart%>?idQuestionarie='+idQuestionarie;
        reload(url, id);
    }
</script>
<p>* Seleccione el cuestionario y la secci&oacute;n a la que pertenece la pregunta que desea agregar</p>
<form id="addQuestion" name="addQuestion" action="">
    <table width="100%">
        <tr>
            <td>
                <p>Cuestionario</p>
            </td>
            <td>
                <select name="cuestionario" onchange="changeDisplayQuestions(this.form);">
                    <!-- llena listado de cuestionarios -->
                    <%
                                Iterator<Questionnaire> qs = Questionnaire.ClassMgr.listQuestionnaires(site);
                                while (qs.hasNext())
                                {
                                    Questionnaire q = qs.next();
                                    String title = q.getTitle();
                                    String id = q.getId();
                    %>
                    <option value="<%=id%>"><%=title%></option>
                    <%
                                }
                    %>
                </select>
            </td>
            <td colspan="2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <p>Parte</p>
            </td>
            <td>

                <select name="parte">
                    <%
                                Iterator<Part> partes = Part.ClassMgr.listParts(site);
                                while (partes.hasNext())
                                {
                                    Part part = partes.next();
                                    String title = part.getTitle();
                                    String id = part.getId();
                    %>
                    <option value="<%=id%>"><%=title%></option>
                    <%
                                }
                    %>
                    <!-- llena listado de partes -->
                </select>


            </td>
            <td>
                <p>Secci&oacute;n</p>
            </td>
            <td>
                <select name="seccion">
                    <!-- llena listado de seccion -->
                    <%
                                Iterator<Section> sections = Section.ClassMgr.listSections(site);
                                while (sections.hasNext())
                                {
                                    Section section = sections.next();
                                    String title = section.getTitle();
                                    String id = section.getId();
                    %>
                    <option value="<%=id%>"><%=title%></option>
                    <%

                                }
                    %>
                </select>
            </td>
        </tr>
    </table>
</form>
<br>
<div id="showQuestions">
    <jsp:include flush="true" page="showQuestions.jsp"/>
</div>

<br>
<br>


<input type="button" value="Agregar Pregunta" onclick="showAddQuestion()">