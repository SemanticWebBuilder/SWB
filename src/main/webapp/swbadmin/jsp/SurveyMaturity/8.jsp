<%@page import="java.util.Calendar"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
            int anio = Calendar.getInstance().get(Calendar.YEAR)-1;
%>
<p>Pregunta 11: Por favor capture el porcentaje de incremento para cada año que usted prevea para todo el Portafolio de servicios de aplicaciones.<br>
    Pregunta 12: Por favor capture el porcentaje de incremento para cada año que usted prevea para todo el Portafolio de Servicios de Infraestructura.<br>
    Pregunta 13: Por favor capture el porcentaje de incremento para cada año que usted prevea para todo el Portafolio de Servicios a Usuarios.<br>
    Pregunta 14: Por favor capture el porcentaje de incremento para cada año que usted prevea para todo el Portafolio de Servicios de Gestión.<br>
    Pregunta 15: Por favor capture el porcentaje de incremento para cada año que usted prevea para todo el Portafolio de Servicios de Proyectos.<br>
</p>
<script type="text/javascript">
    function calcula(forma)
    {
        
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
        /*if(parseInt(value)>100)
        {
            alert(title+" no puede ser mayor a 100%");
            field.focus();
            return false;
        }*/
        return true;
    }
    String.prototype.startsWith = function(str)
    {
        return (this.match("^"+str)==str)
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
    function valida(forma)
    {
        var x=forma;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_'))
            {
                var pos=name.lastIndexOf('_');
                var anio='';

                if(pos!=-1)
                {
                    anio=name.substring(pos+1);
                }
                var title='para el año '+anio;
                if(name.startsWith('p_aplicaciones_'))
                {
                    title='Portafolio de servicios de aplicaciones '+title;
                }
                if(name.startsWith('p_infra_'))
                {
                    title='Portafolio de Servicios de Infraestructura '+title;
                }
                if(name.startsWith('p_servicios_'))
                {
                    title='Portafolio de Servicios a Usuarios '+title;
                }
                if(name.startsWith('p_gestion_'))
                {
                    title='Portafolio de Servicios de Gestión '+title;
                }
                if(name.startsWith('p_proyectos_'))
                {
                    title='Portafolio de Servicios de Proyectos '+title;
                }
                if(!validaPorcentaje(x.elements[i],title))
                {
                    return;
                }
            }
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
            return false;

        calcula(forma);
        return true;
    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="9">
    <input type="hidden" name="from" value="8">
    <table width="100%" cellspacing="3">
        <legend>INCREMENTO EN COSTOS</legend>
        <th>&nbsp;</th>
        <%
                    for (int i = 0; i < 8; i++)
                    {
                        int anio_show = anio + i;
        %>
        <th><%=anio_show%></th>
        <%
                    }
        %>
        <tr>
            <td colspan="9">
                <p>
                    <b>Cambio porcentual anual del Portafolio de servicios de aplicaciones</b>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>Portafolio de servicios de aplicaciones</p>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
                            if (anio_show == anio)
                            {
            %>
            <td>
                <p>Base</p>
            </td>
            <%                                                            }
                                        else
                                        {
            %>

            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicaciones_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>

            <%
                            }

                        }

            %>
        </tr>

        <tr>
            <td colspan="9">
                <p>
                    <b>Cambio porcentual anual del Portafolio de Servicios Propios (Directos) de Infraestructura</b>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>Portafolio de Servicios de Infraestructura</p>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
                            if (anio_show == anio)
                            {
            %>
            <td>
                <p>Base</p>
            </td>
            <%                                                            }
                                        else
                                        {
            %>

            <td>
                <input type="text" size="3" maxlength="3" name="p_infra_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>

            <%
                            }

                        }

            %>
        </tr>


        <tr>
            <td colspan="9">
                <p>
                    <b>Cambio porcentual anual del Portafolio de Servicios a Usuarios</b>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>Portafolio de Servicios a Usuarios</p>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
                            if (anio_show == anio)
                            {
            %>
            <td>
                <p>Base</p>
            </td>
            <%                                                            }
                                        else
                                        {
            %>

            <td>
                <input type="text" size="3" maxlength="3" name="p_servicios_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>

            <%
                            }

                        }

            %>
        </tr>


        <tr>
            <td colspan="9">
                <p>
                    <b>Cambio porcentual anual del Portafolio de Servicios de  Gestión</b>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>Portafolio de Servicios de  Gestión</p>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
                            if (anio_show == anio)
                            {
            %>
            <td>
                <p>Base</p>
            </td>
            <%                                                            }
                                        else
                                        {
            %>

            <td>
                <input type="text" size="3" maxlength="3" name="p_gestion_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>

            <%
                            }

                        }

            %>
        </tr>


        <tr>
            <td colspan="9">
                <p>
                    <b>Cambio porcentual anual del Portafolio de Servicios de Proyectos</b>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <p>Portafolio de Servicios de Proyectos</p>
            </td>
            <%
                        for (int i = 0; i < 8; i++)
                        {
                            int anio_show = anio + i;
                            if (anio_show == anio)
                            {
            %>
            <td>
                <p>Base</p>
            </td>
            <%                                                            }
                                        else
                                        {
            %>

            <td>
                <input type="text" size="3" maxlength="3" name="p_proyectos_<%=anio_show%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>

            <%
                            }

                        }

            %>
        </tr>
        <tr>
            <td colspan="8" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>
