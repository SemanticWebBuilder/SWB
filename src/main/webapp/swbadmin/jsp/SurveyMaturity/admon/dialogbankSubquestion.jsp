<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.questionnaire.BankSubQuestion"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.survey.Admin"%>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();

%>


<script type="text/javascript">
    function closeDialogBankSubquestion()
    {
        dijit.byId("dialogbankSubquestion").hide();
    }
    
    
    function deleteSubquestion(url){
                 var uri = url;
        submitUrl(uri, '');
        update(reloadSubquestion);        
    }

    function sendidSubquestion(title, id){

        document.getElementById('textSub').value = title;
        document.getElementById('sendIdSubquestion').value = id;
      
    }

</script>



<h1>Subpreguntas disponibles</h1><br>
<table width="100%" id="tablebankSubquestion">
    <th >
        Subpreguntas disponibles
    </th>
    <th>
        Acci&oacute;n
    </th>
    <%
        Iterator<BankSubQuestion> sq = BankSubQuestion.ClassMgr.listBankSubQuestions(paramRequest.getWebPage().getWebSite());
        while (sq.hasNext()) {
            BankSubQuestion s = sq.next();
            String title = s.getTitle();
            String id= s.getURI();
    %>
    <tr>
        <td width="80%" >
            <a href="#" onclick="sendidSubquestion('<%=title%>','<%=id%>'); return false;">
            <%=title%>
            </a>
        </td>
        <td>
            <%
                String uri = s.getURI();
                urlAction.setParameter("uri", uri);
            %>              
            
            <a href="#" title="Eliminar" onclick="deleteSubquestion('<%=urlAction.setAction("removeSubquestion")%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>

        </td>
    </tr>
    <%
        }
    %>
 

</table>