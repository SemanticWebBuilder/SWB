<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.questionnaire.BankInstitution"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.questionnaire.BankUnitsSubstantive"%>
<%@page import="java.util.Iterator"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%
    SWBResourceURL urlAction = paramRequest.getActionUrl();
    urlAction.setCallMethod(SWBResourceURL.Call_DIRECT);
    urlAction.setAction("addInstitution");
    WebSite site = paramRequest.getWebPage().getWebSite();

    String id = request.getParameter("id");
    BankInstitution institution = null;
    if (id != null) {
        institution = BankInstitution.ClassMgr.getBankInstitution(id, site);
    }
%>


<script type="text/javascript">
    function closeDialogAddInstitution()
    {
        dijit.byId("dialogaddInstitution").hide();
    }
    function saveDialogaddInstitution(forma)
    {
       
        try
        {   
            var nameInstitution=forma.nameInstitution.value;
            if(!nameInstitution){
                alert('Indique el nombre de la Institución');
                forma.nameInstitution.focus();
                return;
            }
            var sectorInstitution=forma.sectorInstitution.value;
            
            if(!sectorInstitution){
                alert('Indique el sector de la Institución');
                forma.sectorInstitution.focus();
                return;
            }
            var stateInstitution=forma.stateInstitution.value;
            
                if(!stateInstitution){
                alert('Indique el estado al que pertenece la Institución');
                forma.stateInstitution.focus();
                return;
            }
            var acronymInstitution=forma.acronymInstitution.value;
                        
                if(!acronymInstitution){
                alert('Indique las siglas de la Institución');
                forma.acronymInstitution.focus();
                return;
            }
            var addressInstitution=forma.addressInstitution.value;
              
              if(!addressInstitution){
                alert('Indique la dirección de la Institución');
                forma.addressInstitution.focus();
                return;
            }
                       
            
            sendform(forma.id,reloadAdmonInstitution);
            
            forma.nameInstitution.value='';
            forma.sectorInstitution.value='';           
            forma.stateInstitution.value='';
            forma.acronymInstitution.value='';
            forma.addressInstitution.value='';
            
        }
        catch(err)
        {
            alert(err.message);
        }
        dijit.byId("dialogaddInstitution").hide();
    }
    

</script>

<div class="swbform"  region="center" id="faddInstitution">

    <form id="frmAddInstitution"   action="<%=urlAction%>">
    <fieldset>
        <legend>Instituci&oacute;n</legend>  
        
             <%
                if (institution != null) {
                    String institutionid = institution.getId();
            %>

            <input type="hidden" name="institution" value="<%=institutionid%>">
            <%
                }
            %>    
    <table>

        <tr>
            <td colspan="2">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                Nombre de la Institucion:
            </td>
             <td>
                  <%
                            String nombre = "";
                            if (institution != null && institution.getNameInstitution() != null) {
                                nombre = institution.getNameInstitution();
                            }
                        %>
                <input type="text" maxlength="80" size="80" name="nameInstitution" value="<%=nombre%>">
            </td>
        </tr>

        <tr>
            <td>
                Sector:
            </td>
             <td>
                                   <%
                            String sector = "";
                            if (institution != null && institution.getSector() != null) {
                                sector = institution.getSector();
                            }
                        %>
                <input type="text" maxlength="80" size="80" name="sectorInstitution" value="<%=sector%>">
            </td>
        </tr>

        <tr>
            <td>
                Estado:
            </td>
             <td>
                       <%
                            String state = "";
                            if (institution != null && institution.getState() != null) {
                                state = institution.getState();
                            }
                        %>
                <input type="text" maxlength="80" size="80" name="stateInstitution" value="<%=state%>">
            </td>
        </tr>

         <tr>
            <td>
                Siglas:
            </td>
             <td>
                          <%
                            String acronym = "";
                            if (institution != null && institution.getAcronym() != null) {
                                acronym = institution.getAcronym();
                            }
                        %>
                <input type="text" maxlength="80" size="80" name="acronymInstitution" value="<%=acronym%>">
            </td>
        </tr>
              <tr>
            <td>
                Direccion:
            </td>
             <td>
                      <%
                            String address = "";
                            if (institution != null && institution.getAddress()!= null) {
                                address = institution.getAddress();
                            }
                        %>
                <input type="text" maxlength="80" size="80" name="addressInstitution" value="<%=address%>">
            </td>
        </tr>
        
        <tr>
            <td>                
              <input type="button" value="Cancelar" onclick="closeDialogAddInstitution()">&nbsp;<input type="button" value="Guardar" onclick="saveDialogaddInstitution(this.form)">
            </td>
        </tr>
    </table>
    </fieldset>
</form>
</div>



