<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"
/><jsp:useBean id="url" scope="request" type="org.semanticwb.portal.api.SWBResourceURL"
/><jsp:useBean id="errMessage" scope="request" type="java.lang.String"
/><script type="text/javascript">
    function valUsr()
    {
        var pwd  = document.getElementById("usrPwd").value;
        var pwd2 = document.getElementById("usrPwd2").value;
        if (pwd!=pwd2) 
        {
            document.getElementById("usrPwd").focus();
            alert('Las claves no son iguales');
            return false;
        }
        
    }
</script><form id="usrReg" action="<%= url %>" onsubmit="return valUsr()" method="post"><div id="errMessage" align="center"><%= errMessage %></div>
    <fieldset>
        <table border="0" cellpadding="0" cellspacing="0">
        <tr><td><label for="usrLogin">Clave de Usuario</label</td><td><input type="text" id="usrLogin" name="usrLogin" /></td></tr>
        <tr><td><label for="usrPwd">Contrase&ntilde;a</label</td><td><input type="password" id="usrPwd" name="usrPwd" /></td></tr>
        <tr><td><label for="usrPwd2">Verificar Contrase&ntilde;a</label</td><td><input type="password" id="usrPwd2" name="usrPwd2" /></td></tr>
        <tr><td colspan="2" align="center"><button type="submit">Registrar</button>
        </table>
    </fieldset>

</form>
