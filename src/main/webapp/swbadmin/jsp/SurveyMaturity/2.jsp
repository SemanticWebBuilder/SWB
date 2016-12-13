<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<p>Pregunta 2.- Favor de proporcionar los Costos de la UTIC que no están considerados en la la información de "Punto de Partida" proporcionada por la SHCP. En caso de coincidir, las cifras reportadas en esta pregunta deberán ser cero (0).</p>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>



<script type="text/javascript">
    <!--
    function valida(forma)
    {
        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
    function calcula(forma)
    {
        var personal=0;
        var out=0;
        var otros=0;
        var tempPersonal=forma.personal.value;
        if(tempPersonal)
        {
            personal=tempPersonal;
        }
        var tempout=forma.outsourcing.value;
        if(tempout)
        {
            out=tempout;
        }
        var temotros=forma.otros.value;
        if(temotros)
        {
            otros=temotros;
        }
        forma.total.value=parseInt(personal)+parseInt(out)+parseInt(otros);
    }
    function isNumberKey(evt,forma)
    {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

        calcula(forma);
        return true;
    }
    //-->
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="3">
    <input type="hidden" name="from" value="2">
    <table>
        <legend>
            <b>Costos de la UTIC no considerados en Cuenta Publica</b>
        </legend>
        <th>&nbsp;</th>
        <th>Cantidad</th>
        <tr>
            <td>
                Costos de Personal
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="personal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>
        <tr>
            <td>
                Costos de Outsourcing
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="outsourcing" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>
        <tr>
            <td>
                Otros Costos
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="otros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>

        <tr>
            <td>
                Total
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="total" disabled>
            </td>
        </tr>

        <!--<tr>
            <td>
                Porcentaje de Costos de Outsourcing que representa Personal (Recursos Humanos)
            </td>
            <td>
                <input type="text" size="4" maxlength="4" name="pOutsourcing" onchange="actualiza(this.form)">
            </td>
            <td>
                <input type="text" size="4" maxlength="4" name="tOutsourcing" disabled>
            </td>
        </tr/>-->
        <tr>
            <td colspan="3" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>
