<%@page import="org.semanticwb.model.GenericIterator"%>
<%@page import="org.semanticwb.questionnaire.Question"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.questionnaire.Questionnaire"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<!-- listado de preguntas -->
<table width="100%">
    <th>Preguntas</th>
    <th>Acci&oacute;n</th>
    <%
                WebSite site = paramRequest.getWebPage().getWebSite();
                String idQuestionarie = request.getParameter("idQuestionarie");
                if (idQuestionarie != null)
                {
                    Questionnaire q = Questionnaire.ClassMgr.getQuestionnaire(idQuestionarie, site);
                    if (q != null)
                    {

                        GenericIterator<Question> questions = q.listQuestions();
                        while (questions.hasNext())
                        {
                            Question question = questions.next();
                            String title = question.getId();
    %>
    <tr>
        <td>
            <p><%=title%></p>
        </td>
        <td>

        </td>
    </tr>
    <%
                        }
                    }
                }
    %>

</table>
