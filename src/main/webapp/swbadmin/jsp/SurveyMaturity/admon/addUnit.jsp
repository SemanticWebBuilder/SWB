<%@page import="org.semanticwb.questionnaire.BankUnitsSubstantive"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.questionnaire.BankInstitution"%>
<%@page import="java.util.Iterator"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();
    urlAction.setCallMethod(SWBResourceURL.Call_DIRECT);
    urlAction.setAction("addUnit");
    WebSite site = paramRequest.getWebPage().getWebSite();

    String id = request.getParameter("id");
    BankUnitsSubstantive unit = null;
    if (id != null) {
        unit = BankUnitsSubstantive.ClassMgr.getBankUnitsSubstantive(id, site);
    }

%>


<script type="text/javascript">
    function closeDialogAddUnit()
    {
        dijit.byId("dialogaddUnit").hide();
    }
    function saveDialogaddUnit(forma)
    {
        try
        {
           
            var nameUnit = forma.nameUnit.value;
            if(!nameUnit){
                alert('Indique el nombre de la Unidad Sustantiva.')
                forma.nameUnit.focus();               
            }

            var  institution = document.getElementById("selectInstitution").value;
            forma.unitInstitution.value= institution;           
            
            sendform(forma.id,reloadAdmonUnit);   
            forma.nameUnit.value='';
            dijit.byId("dialogaddUnit").hide();
        }
        catch(err)
        {
            alert(err.message);
        }
         dijit.byId("dialogaddUnit").hide();   
    }


    

</script>
<div class="swbform"  region="center" id="faddUnit">
    <form id="frmAddUnit"   action="<%=urlAction%>">
        <fieldset>
            <legend>Unidad Sustantiva</legend>

            <%
                if (unit != null) {
                    String unitid = unit.getId();
            %>

            <input type="hidden" name="unit" value="<%=unitid%>">
            <%
                }
            %>

            <input type="hidden" name="unitInstitution">
            <table>
                <tr>

                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>

                </tr>
                <tr>
                    <td>
                        Nombre:
                    </td>
                    <td>
                        <%
                            String nombre = "";
                            if (unit != null && unit.getNameUnitSubstantive() != null) {
                                nombre = unit.getNameUnitSubstantive();
                               
                            }
                        %>
                        <input type="text" maxlength="80" size="80" name="nameUnit" id="nameUnit" value="<%=nombre%>">
                    </td>
                </tr>
                <tr>

                </tr>
            </table>

            <table>
                <tr>
                    <td>
                        <div id="divselectInstitution">
                            <jsp:include flush="true" page="selectInstitute.jsp" />
                        </div>
                    </td>
                </tr>
            </table>
        </fieldset>

        <fieldset>   
            <ul class="swbform-ul">
                <li align="right" >
                    <input type="button" value="Cancelar" onclick="closeDialogAddUnit()">&nbsp;<input type="button" value="Guardar" onclick="saveDialogaddUnit(this.form)">
                </li>
            </ul>
        </fieldset>     
    </form>
</div>