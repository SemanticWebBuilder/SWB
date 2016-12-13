<%@page import="org.semanticwb.questionnaire.BankSubQuestion"%>
<%@page import="org.semanticwb.questionnaire.OptionQuestion"%>
<%@page import="java.util.Iterator"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%@page import="java.net.URLDecoder"%>
<%@page import="org.semanticwb.base.util.URLEncoder"%>
<%@page import="org.semanticwb.portal.api.SWBActionResponse"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.questionnaire.Question"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.questionnaire.BankQuestion"%>
<%@page import="org.semanticwb.questionnaire.Section"%>
<%@page import="org.semanticwb.questionnaire.Part"%>
<%@page import="org.semanticwb.questionnaire.Questionnaire"%>
<%
    String insFilter = request.getParameter("questionSelected") == null ? "" : request.getParameter("questionSelected").toString();
    String partSelected = request.getParameter("partSelected") == null ? "" : request.getParameter("partSelected").toString();
    String sectionSelected = request.getParameter("sectionSelected") == null ? "" : request.getParameter("sectionSelected").toString();
    //System.out.println("cuando entra al filter question.jsp");
    //System.out.println("cuestionario selected"+insFilter);
    //System.out.println("partSelected"+partSelected);
    //System.out.println("sectionSelected"+sectionSelected);
    //System.out.println("cuando entra");    

%>
<!--<body onload="reloadfilterQuestion();"></body>-->
<fieldset>
    <table>
        <th>pregunta</th>
        <th>cuestionario</th>
        <th>parte</th>
        <th>seccion</th>
        <th>nota</th>
        <th>descripcion</th>
        <th>subpreguntas</th>
        <th>respuesta</th>
        <%
            BankQuestion bq;

            String titleQuestionnaire = "";
            String titlePart = "";
            String titleSection = "";

            Iterator<Question> qe = null;
            ArrayList<Question> arrayByParte = new ArrayList<Question>();

            Iterator<Question> questionByQuestionnaire = null;
            Iterator<Question> questionByParte = null;
            Iterator<Section> sect = null;


            Questionnaire r = null;
            if (insFilter != "") {
                r = Questionnaire.ClassMgr.getQuestionnaire(insFilter, paramRequest.getWebPage().getWebSite());
            }

            Part p1 = null;
            if (partSelected != "") {
                p1 = Part.ClassMgr.getPart(partSelected, paramRequest.getWebPage().getWebSite());
            }

            Section section = null;
            if (sectionSelected != null) {
                section = Section.ClassMgr.getSection(sectionSelected, paramRequest.getWebPage().getWebSite());
            }
            //System.out.println("cuestionario" + insFilter);
            //System.out.println("parte=" + partSelected);
            //System.out.println("seccion=" + sectionSelected);

            //empieza los filtrados
            if (insFilter != "" && partSelected.equals("") && sectionSelected.equals("")) {
                //System.out.println("----------->FILTRA MUESTRA SOLO POR CUESTIONARIO<------------");
                qe = Question.ClassMgr.listQuestionByOptionQuestionnaire(r);

            } else if (insFilter != "" && partSelected != "" && sectionSelected.equals("")) {
                //System.out.println("-------------->FILTRA POR CUESTIONARIO Y PARTE<------------------");
                questionByQuestionnaire = Question.ClassMgr.listQuestionByOptionQuestionnaire(r);
                questionByParte = Question.ClassMgr.listQuestionByOptionPart(p1);



                while (questionByQuestionnaire.hasNext()) {
                    Question qeByQuestio = questionByQuestionnaire.next();
                    if (qeByQuestio.getOptionPart().getId().equals(partSelected)) {
                        arrayByParte.add(qeByQuestio);
                    }
                }

                qe = arrayByParte.iterator();



            } else if (insFilter != "" && partSelected != "" && sectionSelected != "") {
                //System.out.println("-------------->FILTRA POR CUESTIONARIO  PARTE Y SECCION<------------------");
                questionByQuestionnaire = Question.ClassMgr.listQuestionByOptionQuestionnaire(r);
                questionByParte = Question.ClassMgr.listQuestionByOptionPart(p1);
                questionByParte = Question.ClassMgr.listQuestionByOptionSection(section);
                
                 while (questionByQuestionnaire.hasNext()) {
                    Question qeByQuestio = questionByQuestionnaire.next();
                    if (qeByQuestio.getOptionPart().getId().equals(partSelected)) {
                        arrayByParte.add(qeByQuestio);
                    }
                }
                
                Iterator<Question>  ip = arrayByParte.iterator();
                ArrayList<Question> arrayByPart = new ArrayList<Question>();
                while(ip.hasNext()){
                    Question w = ip.next();
                    if(w.getOptionSection().getId().equals(sectionSelected)){
                    arrayByPart.add(w);
                    }                
                }
                   
                qe = arrayByPart.iterator();                


            } else {
               
                qe = Question.ClassMgr.listQuestions(paramRequest.getWebPage().getWebSite());


            }


            //iteramos la lista filtrada
            while (qe.hasNext()) {
                Question q = qe.next();
                bq = q.getQuestionBank();

                if (q.getOptionQuestionnaire() != null) {
                    r = q.getOptionQuestionnaire();
                    titleQuestionnaire = r.getTitle();
                }
                if (q.getOptionPart() != null) {
                    p1 = q.getOptionPart();
                    titlePart = p1.getTitle();

                }
                if (q.getOptionSection() != null) {
                    section = q.getOptionSection();
                    titleSection = section.getTitle();
                }


        %>
        <tr>
            <td><%=bq.getTextQuestion()%></td>
            <td><%=titleQuestionnaire%></td>
            <td><%=titlePart%> </td>
            <td><%=titleSection%></td>
            <td><%=bq.getNote()%></td>
            <td><%=bq.getDescription()%></td>            
            <td>            
            </td>
            <td> </td>
        </tr>
        <%

            }

        %>

    </table>

</fieldset>
