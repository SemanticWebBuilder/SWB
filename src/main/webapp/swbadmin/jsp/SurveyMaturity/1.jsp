<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>
<p>Pregunta 1.- Para la informaci�n de "Punto de Partida", Favor de indicar si el COSTO de TIC TOTAL de la Instituci�n coincide con la informaci�n de la Cuenta p�blica proporcionada por la SHCP.</p>
<p>�Es correcto el El COSTO de TIC TOTAL de la Instituci�n?</p>
<script type="text/javascript">
    function valida(forma)
    {
        if(confirm('�Es correcta la informaci�n?'))
        {
            forma.submit();
        }
    }

</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="2">
    <input type="hidden" name="from" value="1">
    <input type="radio" name="shcp" value="1" checked>1 )	S� es correcto y corresponde al informado por SHCP<br>
    <input type="radio" name="shcp" value="2">2)	No es correcto, es mayor al informado por SHCP<br>
    <input type="radio" name="shcp" value="3">3)	No es correcto, es menor al informado por SHCP<br><br>
    <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
</form>







