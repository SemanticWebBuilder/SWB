<%@page import="java.util.Calendar"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
            int anio = Calendar.getInstance().get(Calendar.YEAR) - 1;
            Map<String, String> aplicaciones = new HashMap<String, String>();
            aplicaciones.put("1", "Aplicacion 1");
            aplicaciones.put("2", "Aplicacion 2");
            aplicaciones.put("3", "Aplicacion 3");
%>
<p>
    Pregunta 16: Enumere las cinco principales aplicaciones de la Institución, determinadas por costo (soporte, mantenimiento, operaciones).<br>
    Pregunta 17: Indique para cada una de las cinco aplicaciones principales, el porcentaje del costo total del Portafolio de Servicios de Aplicaciones que le corresponde.  Además, Por favor capture el porcentaje de incremento para cada año que usted prevea para esas cinco aplicaciones.
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
    String.prototype.endsWith = function(suffix) {
        return this.match(suffix+"$") == suffix;
    };
    function calcula(forma)
    {
        var p_costo_=0;
        var x=forma;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_costo_'))
            {
                if(x.elements[i].value)
                {
                    p_costo_+=parseInt(x.elements[i].value);

                }
            }
        }
        forma.t_subtotal_costo_.value=p_costo_;



        var ianio=<%=anio%>;
        var i=0;
        for(i=0;i<8;i++)
        {
            var anioshow=i+ianio;
            var total_anio=0;
            for (var j=0;j<x.length;j++)
            {
                var name=x.elements[j].name;
                if(name.endsWith(anioshow) && name.startsWith('p_incremento_'))
                {
                    if(x.elements[j].value)
                    {
                        total_anio+=parseInt(x.elements[j].value);

                    }
                }
            }
            forma.elements['t_subtotal_incremento_'+anioshow].value=total_anio;

        }
        var resto=0;
        if(forma.p_resto_.value)
        {
            resto=parseInt(forma.p_resto_.value);
        }
        forma.t_costo_.value=p_costo_+resto;

        for(i=0;i<8;i++)
        {
            var anioshow=i+ianio;
            var total_anio=0;
            total_anio+=parseInt(forma.elements['t_subtotal_incremento_'+anioshow].value);
            total_anio+=parseInt(forma.elements['p_resto_'+anioshow].value);
            forma.elements['t_total_'+anioshow].value=total_anio;
        }

        
    }
    function valida(forma)
    {
        calcula(forma);

        var costo_aplicaciones=parseInt(forma.t_costo_.value);
        if(parseInt(costo_aplicaciones)>100)
        {
            alert('El % TOTAL del Costo total del Portafolio de servicios de aplicaciones no puede ser mayor de 100%');
            return;
        }

        if(parseInt(costo_aplicaciones)<100)
        {
            alert('El % TOTAL del Costo total del Portafolio de servicios de aplicaciones debe sumar 100%');
            return;
        }

        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="10">
    <input type="hidden" name="from" value="9">
    <table cellspacing="3" cellpadding="2">
        <legend>COSTOS 5 APLICACIONES</legend>
        <th>Aplicaciones</th>
        <th>%  del Costo total del Portafolio de servicios de aplicaciones</th>
        <%
                    for (int i = 0; i < 8; i++)
                    {
                        int anio_show = anio + i;
        %>
        <th><%=anio_show%></th>
        <%
                    }
        %>
        <%
                    for (String clave : aplicaciones.keySet())
                    {
                        String nombre = aplicaciones.get(clave);

        %>
        <tr>
            <td>
                <p><%=nombre%></p>
            </td>
            <td align="center">
                <input type="text" size="3" maxlength="3" name="p_costo_<%=clave%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <%
                                    for (int i = 0; i < 8; i++)
                                    {
                                        int anio_show = anio + i;
            %>
            <td>
                <input type="text" size="3" maxlength="3" name="p_incremento_<%=clave%>_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <%
                                    }
            %>
        </tr>
        <%
                    }
        %>
        <tr>
            <td><p>
                    Total 5 Aplicaciones

                </p></td>
            <td align="center">
                <input type="text" size="3" maxlength="3" name="t_subtotal_costo_" disabled>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
            %>
            <td>
                <input type="text" size="3" maxlength="3" name="t_subtotal_incremento_<%=anio_show%>" disabled>
            </td>
            <%
                        }
            %>
        </tr>

        <tr>
            <td>
                <p>
                    Todas las demás Aplicaciones
                </p>
            </td>
            <td align="center">
                <input type="text" size="3" maxlength="3" name="p_resto_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
            %>
            <td>
                <input type="text" size="3" maxlength="3" name="p_resto_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <%
                        }
            %>
        </tr>

        <tr>
            <td>
                <p>
                    Total Aplicaciones

                </p>
            </td>
            <td align="center">
                <input type="text" size="3" maxlength="3" name="t_costo_" disabled>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
            %>
            <td>
                <input type="text" size="3" maxlength="3" name="t_total_<%=anio_show%>" disabled>
            </td>
            <%
                        }
            %>
        </tr>
        <tr>
            <td colspan="10" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>
