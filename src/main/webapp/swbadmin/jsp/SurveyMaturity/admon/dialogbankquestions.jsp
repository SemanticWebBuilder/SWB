<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.questionnaire.BankQuestion"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.survey.Admin"%>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();

%>


<script type="text/javascript">
    function closeBankQuestions()
    {
        dijit.byId("dialogaddbankQuestions").hide();
    }
    function saveBankQuestions(forma)
    {
        dijit.byId("dialogaddbankQuestions").hide();
    }
    
    function sendidquestion(title, id){


        document.getElementById('textquestion').value = title;
        document.getElementById('idDialogBankQuestion').value = id;
      
    }
    
    function deletequestion(url){
        var uri = url;
        submitUrl(uri, '');
        update(reloadBankQuestion); 

        
    }
</script>
<h1>Preguntas disponibles</h1><br>
<table width="100">
    <th>
        Preguntas disponibles
    </th>
    <th>
        Acci&oacute;n
    </th>
    <%
        Iterator<BankQuestion> sq = BankQuestion.ClassMgr.listBankQuestions(paramRequest.getWebPage().getWebSite());
        while (sq.hasNext()) {
            BankQuestion s = sq.next();
            String title = s.getTextQuestion();
            String id = s.getURI();
    %>
    <tr>
        <td width="80%" >
            <a href="#" onclick="sendidquestion('<%=title%>','<%=id%>'); return false;">
                <%=title%>
            </a>
        </td>
        <td>
            <%
                String uri = s.getURI();
                urlAction.setParameter("uri", uri);
            %>              

            <a href="#" title="Eliminar" onclick="deletequestion('<%=urlAction.setAction("removeBankquestion")%>');"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>

        </td>
    </tr>
        <%
        }
    %>
</table>
<table>
    <tr>

        <td colspan="2" align="center">
            <a href=""><<</a> &nbsp; <input type="text" size="3" maxlength="3"> &nbsp; <a href="">>></a>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="center">
            &nbsp;
        </td>
    </tr>
    <tr>
        <td colspan="2" align="center">
            <input type="button" value="Cancelar" onclick="closeBankQuestions();">&nbsp;<input type="button" value="Agregar" onclick="saveBankQuestions(this.form);">
        </td>
    </tr>
</table>