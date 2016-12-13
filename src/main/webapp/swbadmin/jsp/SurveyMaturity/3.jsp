<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>
<p>Pregunta 3.- Una vez que validó la información del "Punto de Partida" de los datos proporcionados por la SHCP, por favor registre los Montos correspondientes a cada una de las tres categorías básicas de los costos de TI</p>

<script type="text/javascript">
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
    function actualiza(forma)
    {
        var pOutsourcing=forma.pOutsourcing.value;
        if(!pOutsourcing)
        {
            forma.pOutsourcing.value='';
            return;
        }
        var outsourcing=forma.outsourcing.value;
        if(!outsourcing)
        {
            forma.pOutsourcing.value='';
            return;
        }
        var total=outsourcing*pOutsourcing;
        forma.pOutsourcing.value=total;
    }
    function valida(forma)
    {
        calcula(forma);
        var mpersonal=forma.mpersonal.value;
        if(!mpersonal)
        {
            alert('Indique el Costo Total de Personal');
            forma.mpersonal.focus();
            return;
        }
        var moutsourcing=forma.moutsourcing.value;
        if(!moutsourcing)
        {
            alert('Indique el Costo Total de Personal');
            forma.moutsourcing.focus();
            return;
        }
        var motros=forma.motros.value;
        if(!motros)
        {
            alert('Indique el Costo Total de Otros Costos');
            forma.motros.focus();
            return;
        }
        var pcostoout=forma.pcostoout.value;
        if(!pcostoout)
        {
            alert('Indique el Porcentaje de los costos de outsourcing que representan al personal');
            forma.pcostoout.focus();
            return;
        }
        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
    function isNumberKey(evt,forma)
    {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
        {
            
            return false;
        }
        calcula(forma);
        return true;
    }
    function calcula(forma)
    {
        var personal=0;
        var out=0;
        var otros=0;
        var tempPersonal=forma.mpersonal.value;
        if(tempPersonal)
        {
            personal=tempPersonal;
        }
        var tempout=forma.moutsourcing.value;
        if(tempout)
        {
            out=tempout;
        }
        var temotros=forma.motros.value;
        if(temotros)
        {
            otros=temotros;
        }
        forma.mtotal.value=parseInt(personal)+parseInt(out)+parseInt(otros);
        if(parseInt(forma.mtotal.value)==0)
        {

            forma.ppersonal.value=0;
            forma.poutsourcing.value=0;
            forma.potros.value=0;
        }
        else
        {
            
            var ppersonal=(parseInt(personal)/parseInt(forma.mtotal.value))*100;
            forma.ppersonal.value=ppersonal;


            var poutsourcing=(parseInt(out)/parseInt(forma.mtotal.value))*100;
            forma.poutsourcing.value=poutsourcing;

            var potros=(parseInt(otros)/parseInt(forma.mtotal.value))*100;
            forma.potros.value=potros;
        }
        var pcostoout=forma.pcostoout.value;
        if(pcostoout)
        {
            if(parseInt(pcostoout)>100)
            {
                alert('El Porcentaje de los costos de outsourcing que representan al personal no puede ser mayor a 100%');
                return;
            }
            var monto=(out*parseInt(pcostoout))/100;
            forma.mcostoout.value=monto;
        }
        forma.ptotal.value=100;

    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="4">
    <input type="hidden" name="from" value="3">
    <table>
        <th>&nbsp;</th>
        <th>Monto</th>
        <th>%</th>
        <tr>
            <td>
                Costo Total de Personal
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="mpersonal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="ppersonal" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Costo Total de Outsourcing
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="moutsourcing" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="poutsourcing" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Costo Total de Otros Costos
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="motros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="potros" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Total
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="mtotal" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="ptotal" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <p>
                    Pregunta 3-B:   De la suma mostrada para Outsourcing, ¿qué porcentaje representa al personal (recursos humanos)? Esto incluye a los contratistas, personas que brindan servicios de mantenimiento u operativos, etc. En otras palabras, si la actividad cubierta por el Outsourcing (servicios contratados) se desarrollara dentro de la organización de TICs,  ¿qué porcentaje de los costos correspondería a personal o recursos humanos?
                </p>
            </td>
        </tr>

        <tr>
            <td>
                Porcentaje de los costos de outsourcing que representan al personal
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="pcostoout" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="mcostoout" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>