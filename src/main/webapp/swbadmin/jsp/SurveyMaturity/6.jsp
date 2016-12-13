<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<p>
    Pregunta 6: Por favor anote el % del costo de cada Servicio de TIC, consumido por cada unidad sustantiva.  La suma de los porcentajes debe ser igual a 100%.
</p>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
            Map<String, String> unidades = new HashMap<String, String>();
            unidades.put("59", "infotec 1");
            unidades.put("60", "infotec 2");



%>
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
        var x=forma;
        var t_aplicacion_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_aplicacion_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    t_aplicacion_+=parseInt(value);
                }
            }
        }
        forma.t_aplicacion_.value=t_aplicacion_;


        var t_infra_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_infra_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    t_infra_+=parseInt(value);
                }
            }
        }
        forma.t_infra_.value=t_infra_;



        var t_servicios_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_servicios_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    t_servicios_+=parseInt(value);
                }
            }
        }
        forma.t_servicios_.value=t_servicios_;


        var t_gestion_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_gestion_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    t_gestion_+=parseInt(value);
                }
            }
        }
        forma.t_gestion_.value=t_gestion_;


        var t_proyectos_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_proyectos_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    t_proyectos_+=parseInt(value);
                }
            }
        }
        forma.t_proyectos_.value=t_proyectos_;



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
    String.prototype.startsWith = function(str)
    {
        return (this.match("^"+str)==str)
    }
    function valida(forma)
    {
        calcula(forma);
        var x=forma;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;            
            if(name.startsWith('p_'))
            {
                
                var pos=name.lastIndexOf('_');
                var id='';

                if(pos!=-1)
                {
                    id=name.substring(pos+1);
                }
                
                var str_title='';                
                var title=x.elements['title_'+id];                
                if(title)
                {
                    str_title=title.value;
                }
                if(name.indexOf('_aplicacion_')!=-1)
                {
                    str_title='% de  los Costos del Portafolio de servicios de aplicaciones para '+str_title;
                }
                if(name.indexOf('_infra_')!=-1)
                {
                    str_title='% de Costos del Portafolio de Servicios Propios (Directos) de Infraestructura para '+str_title;
                }
                if(name.indexOf('_servicios_')!=-1)
                {
                    str_title='% de los Costos del Portafolio de Servicios al Usuario para '+str_title;
                }
                if(name.indexOf('_gestion_')!=-1)
                {
                    str_title='% de los Costos del Portafolio de Servicios de Gestión de TIC para '+str_title;
                }
                if(name.indexOf('_proyectos_')!=-1)
                {
                    str_title='% de Costos del Portafolio de Servicios de Proyecto para '+str_title;
                }
                if(!validaPorcentaje(x.elements[i],str_title))
                {
                    return;
                }
            }
        }


        var t_aplicacion_=forma.t_aplicacion_.value;
        if(parseInt(t_aplicacion_)>100)
        {
            alert('El % TOTAL de los Costos del Portafolio de servicios de aplicaciones no puede ser mayor de 100%');
            return;
        }

        if(parseInt(t_aplicacion_)<100)
        {
            alert('El % TOTAL de los Costos del Portafolio de servicios de aplicaciones debe sumar 100%');
            return;
        }

        var t_infra_=forma.t_infra_.value;
        
        if(parseInt(t_infra_)>100)
        {
            alert('El % TOTAL de Costos del Portafolio de Servicios Propios (Directos) de Infraestructura no puede ser mayor de 100%');
            return;
        }

        if(parseInt(t_infra_)<100)
        {
            alert('El % TOTAL de Costos del Portafolio de Servicios Propios (Directos) de Infraestructura debe sumar 100%');
            return;
        }


        var t_servicios_=forma.t_servicios_.value;
        if(parseInt(t_servicios_)>100)
        {
            alert('El % TOTAL de los Costos del Portafolio de Servicios al Usuario no puede ser mayor de 100%');
            return;
        }

        if(parseInt(t_servicios_)<100)
        {
            alert('El % TOTAL de los Costos del Portafolio de Servicios al Usuario debe sumar 100%');
            return;
        }


        var t_gestion_=forma.t_gestion_.value;
        if(parseInt(t_gestion_)>100)
        {
            alert('El % TOTAL de los Costos del Portafolio de Servicios de Gestión de TIC no puede ser mayor de 100%');
            return;
        }

        if(parseInt(t_gestion_)<100)
        {
            alert('El % TOTAL de los Costos del Portafolio de Servicios de Gestión de TIC debe sumar 100%');
            return;
        }

        var t_proyectos_=forma.t_proyectos_.value;
        if(parseInt(t_proyectos_)>100)
        {
            alert('El % TOTAL de Costos del Portafolio de Servicios de Proyecto no puede ser mayor de 100%');
            return;
        }

        if(parseInt(t_proyectos_)<100)
        {
            alert('El % TOTAL de Costos del Portafolio de Servicios de Proyecto debe sumar 100%');
            return;
        }


        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="7_1">
    <input type="hidden" name="from" value="6">
    <table>
        <legend>Conformación de los Costos de TIC de las Unidades Sustantivas</legend>
        <th>Unidad Sustantiva</th>
        <th>% de  los Costos del Portafolio de servicios de aplicaciones para cada Unidad Sustantiva</th>
        <th>% de Costos del Portafolio de Servicios Propios (Directos) de Infraestructura para cada Unidad Sustantiva</th>
        <th>% de los Costos del Portafolio de Servicios al Usuario para Cada Unidad Sustantiva</th>
        <th>% de los Costos del Portafolio de Servicios de Gestión de TIC para cada Unidad Sustantiva</th>
        <th>% de Costos del Portafolio de Servicios de Proyecto para Cada Unidad Sustantiva</th>
        <%
                    for (String clave : unidades.keySet())
                    {
                        String nombre = unidades.get(clave);
        %>
        <tr>
            <td>
                <p><%=nombre%></p>
                <input type="hidden" name="title_<%=clave%>" value="<%=nombre%>">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_<%=clave%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_infra_<%=clave%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_servicios_<%=clave%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_gestion_<%=clave%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_proyectos_<%=clave%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>
        <%
                    }
        %>
        <tr>
            <td>
                <p>Resto de las Unidades</p>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_infra_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_servicios_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_gestion_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_proyectos_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
        </tr>

        <tr>
            <td>
                <p>Total</p>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_aplicacion_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_infra_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_servicios_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_gestion_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_proyectos_" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="5" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>