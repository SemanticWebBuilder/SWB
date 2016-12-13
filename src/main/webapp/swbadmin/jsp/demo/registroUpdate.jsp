<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"
/><jsp:useBean id="url" scope="request" type="org.semanticwb.portal.api.SWBResourceURL"
/><jsp:useBean id="errMessage" scope="request" type="java.lang.String"
/><form id="usrReg" action="<%= url %>" onsubmit="return valUsr()" method="post"><div id="errMessage" align="center"><%= errMessage %></div>
    <fieldset>
        <table border="0" cellpadding="0" cellspacing="0">
        <tr><td><label for="usrFName">Nombre</label</td><td><input type="text" id="usrFName" name="usrFName" /></td></tr>
        <tr><td><label for="usrLName">Apellido</label</td><td><input type="text" id="usrLName" name="usrLName" /></td></tr>
        <tr><td><label for="usrMail">Correo electr&oacute;nico</label</td><td><input type="text" id="usrMail" name="usrMail" /></td></tr>
        <tr><td><label for="usrRol">Me considero como</label</td><td>
            <select id="usrRol" name="usrRol">
                <option value=""></option>
                <%
                java.util.Iterator<org.semanticwb.model.Role> lista = paramRequest.getUser().getUserRepository().listRoles();
                while (lista.hasNext()){
                    org.semanticwb.model.Role actRole = lista.next();
                %><option value="<%= actRole.getId() %>"><%=actRole.getTitle()%></option>
                <% } %>
            </select>
        </td></tr>
        <tr><td colspan="2" align="center"><button type="submit">Registrar</button>
        </table>
    </fieldset>

</form>
