<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>
<p>
    Pregunta 22: Por favor estime el porcentaje del costo total de TIC (operaciones y desarrollo) en estas dos categorías.
</p>
<script type="text/javascript">
    function isNumberKey(evt,forma)
    {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

        calcula(forma);
        return true;
    }
    function calcula(forma)
    {
        var p_total=0;
        if(forma.p_front.value)
        {
            p_total+=parseInt(forma.p_front.value);
        }
         if(forma.p_back.value)
        {
            p_total+=parseInt(forma.p_back.value);
        }
        forma.p_total.value=p_total;
    }
    function valida(forma)
    {
        calcula(forma);
        if(!validaPorcentaje(forma.p_front, 'Porcentaje del Costo total de TIC en apoyo del "Front Office"'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_back, 'Porcentaje del Costo total de TIC en apoyo del "Back Office""'))
        {
            return;
        }
        var front=parseInt(forma.p_front.value);
        var back=parseInt(forma.p_back.value);
        var total=front+back;
        if(total>100)
        {
            alert('El % TOTAL no puede ser mayor de 100%');
            return;
        }

        if(total<100)
        {
            alert('El % TOTAL debe sumar 100%');
            return;
        }
        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
    function validaParametroPorcentaje(value)
    {
        if(value.indexOf("-")!=-1)
        {
            return false;
        }
        var patt=new RegExp("[0-9]{1,3}","ig");
        var res=patt.exec(value);
        if(res==null || res.length!=1)
        {
            return false;
        }
        else
        {
            if(res[0].length!=value.length)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
    function validaPorcentaje(field,title)
    {
        var value=field.value;
        if(!value)
        {
            alert('Indique '+title);
            field.focus();
            return false;
        }
        if(!validaParametroPorcentaje(value))
        {
            alert(title+" es inválido");
            field.focus();
            return false;
        }
        if(parseInt(value)>100)
        {
            alert(title+" no puede ser mayor a 100%");
            field.focus();
            return false;
        }
        return true;
    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="14">
    <input type="hidden" name="from" value="13">
    <table cellpadding="2" cellspacing="3">
        <tr>
            <td>
                <p>Porcentaje del Costo total de TIC en apoyo del "Front Office"</p>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_front" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>
        <tr>
            <td>
                <p>Porcentaje del Costo total de TIC en apoyo del "Back Office"</p>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_back" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>
        <tr>
            <td>
                <p>Total</p>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_total" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>


</form>

    <p>
        <b>Front Office.</b> Las actividades de Front Office de la Institución son aquellas que están dirigidas a clientes u otras instituciones externas.<br>
        <b>Back Office.</b> Las actividades de Back Office de la Institución son aquellas que no están dirigidas en forma específica a clientes u otras dependencias externas, es decir, son el soporte interno.

    </p>