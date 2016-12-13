<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.semanticwb.questionnaire.BankSubQuestion"%>

<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();
    urlAction.setCallMethod(SWBResourceURL.Call_DIRECT);
    urlAction.setAction("addSub");
%>

<script type="text/javascript">
    function closeDialogAddSubQuestion()
    {
        dijit.byId("dialogaddSubquestions").hide();
        dijit.byId("dialogaddCuestion").show();
        
    }
    function saveDialogAddSubQuestion(forma)   {
        try
        {   
             var textSub=forma.textSub.value;
            if(!textSub)
            {
                alert('Indique el texto de la pregunta');
                forma.textquestion.focus();
                return;
            }
            var validationSub = "addtheQuestionandsave";
            var  type = document.getElementById("typeSub").value;
            forma.subType.value=type;
            forma.validationSub.value=validationSub;         

            sendform(forma.id, reloadSubquestion); 
            reloadDivrefreshSubquestion(); 
            dijit.byId("dialogaddSubquestions").hide();
            dijit.byId("dialogaddCuestion").show();
        }
        catch(err)
        {
            alert(err.message);
        }    
    }
    
    function mostrarBancoSub(){
        dijit.byId("dialogbankSubquestion").show();
            
    }
    
    function pruebaAddsub(forma){
        try
        {
            var validationSub = "addtheQuestion";

            var  type=document.getElementById("typeSub").value;
            var uri = document.getElementById('sendIdSubquestion').value ;

            
        
            forma.subType.value=type;
            forma.uriAddSubquestion.value=uri;
            forma.validationSub.value=validationSub ;

            sendform(forma.id, reloadDivrefreshSubquestion);
       
            dijit.byId("dialogaddSubquestions").hide();
            dijit.byId("dialogaddCuestion").show();
        }
        catch(err)
        {
            alert(err.message);
        }
        


    }
</script>


<div class="swbform" region="center" id="faddSubquestion">
    <form id="frmAddSub" action="<%=urlAction%>">

        <fieldset>
            <!--le qute el id-->
            <legend>Agregar Subpregunta</legend>

            <table>
                <input type="hidden" name="subType">
                <input type="hidden" name="uriAddSubquestion">
                <input type="hidden" name="sendIdSubquestion" id="sendIdSubquestion">
                <input type="hidden" name="validationSub" id="validationSub">
                <tr>
                    <td>
                        Texto de subpregunta:
                    </td>
                    <td>
                        <textarea cols="80" rows="10" id="textSub" name="textSub"></textarea>
                    </td>
                </tr>

            </table>

            <table>
                <tr>
                    <td>
                        Tipo de respuesta:
                    </td>
                    <td>
                        <select name="typeSub" id="typeSub">
                            <option value="texto">Texto</option>
                            <option value="numerica">Numerica</option>
                        </select>
                    </td>

                </tr>
                <tr>
                    <td colspan="2" align="right">

                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <input type="button" value="Selecionar de banco de subpreguntas" onclick="mostrarBancoSub();">
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        &nbsp;
                    </td>
                </tr>

            </table>



            <div title="Banco de Subpreguntas" open="false" dojoType="dijit.TitlePane" duration="150" minSize_="20" splitter_="true" region="bottom">
                <div id="divdialogbankSubquestion">
                    <jsp:include flush="true" page="dialogbankSubquestion.jsp" />
                </div>
            </div>

    
  
            <table>
                <tr>
                    <td colspan="2" align="right">
                        <input type="button" value="Cancelar" onclick="closeDialogAddSubQuestion();">&nbsp;<input type="button" value="Guardar" onclick="saveDialogAddSubQuestion(this.form)">&nbsp;<input type="button" value="Agregar a pregunta" onclick="pruebaAddsub(this.form)">
                    </td>
                </tr>
            </table>
    </fieldset>
    </form>
</div>