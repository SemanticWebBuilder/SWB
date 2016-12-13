<%@page import="java.util.ArrayList"%>
<%@page import="com.bigdata.bfs.Document"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.questionnaire.BankSubQuestion"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.survey.Admin"%>

<%
            SWBResourceURL urlAction = paramRequest.getActionUrl();
            ArrayList<BankSubQuestion> lista = new ArrayList();
            
            //BankSubQuestion s = (BankSubQuestion) SemanticObject.createSemanticObject(uri).createGenericInstance();
        
            String title = "";
            if (session.getAttribute("idNewSubQ") != null) {
                String uriSub = (String) session.getAttribute("idNewSubQ");
                System.out.println(uriSub);
                lista = (ArrayList<BankSubQuestion>) session.getAttribute("listaTemporal");
                Iterator g = lista.iterator();
                while (g.hasNext()) {
                    System.out.println("lista de banksubquestionen el jsp:" + g.next());
                }
            }

%>
<script type="text/javascript">
    function traerId(){
        
        var z = document.getElementById('sendIdSubquestion').value ;

    }
        function addSubPreguntas()
    {
        dijit.byId("dialogaddCuestion").hide();
        dijit.byId("dialogaddSubquestions").show();
    }
    
    function deleteSubQuetheQue(urlAction){
        var uri = urlAction;
        submitUrl(uri, '');
       //falta que mande a recargar el div de subpreguntas ---->
      
       update(reloadDivrefreshSubquestion);   
        
        
    }
</script>


<table width="100%">
    <td>
        Subpreguntas:
    </td>
    <td width="90%">
        <table width="100%">
            <th>Subpregunta</th>
            <th>Acci&oacute;n</th>

            <%
                        String pintarTit = "";
                        Iterator it = lista.iterator();
                        while (it.hasNext()) {
                            BankSubQuestion x = (BankSubQuestion) it.next();
                            pintarTit = x.getTitle();
                            String uri = x.getURI();   
                            urlAction.setParameter("uri", uri);

            %>
            <tr>
                <td>
                    <%=pintarTit%>
                </td>
                <td width="10%">                    
                    <a href="#" title="Eliminar" onclick="deleteSubQuetheQue('<%=urlAction.setAction("removeSubqueQue")%>')"><img src="/swbadmin/jsp/SurveyMaturity/images/delete.png"></a>
                </td>
            </tr>

            <%
               }
            %>
                <tr>
                    <td></td>
                    <td colspan="2" align="right">
                        <input type="button" value="Agregar SubPreguntas" onclick="addSubPreguntas();">
                    </td>


                </tr>
          
        </table>
    </td>
</table>
