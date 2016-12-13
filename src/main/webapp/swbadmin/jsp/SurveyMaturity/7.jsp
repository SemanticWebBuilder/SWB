<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            class TramiteInfo
            {

                public TramiteInfo(String title, String id)
                {
                    this.title = title;
                    this.id = id;
                }
                String title;
                String id;
            }
            SWBResourceURL url = paramRequest.getActionUrl();
            Map<String, String> unidades = new HashMap<String, String>();
            unidades.put("59", "infotec 1");
            unidades.put("60", "infotec 2");

            Map<String, Set<TramiteInfo>> tramites = new HashMap<String, Set<TramiteInfo>>();
            Set<TramiteInfo> settramites = new HashSet<TramiteInfo>();
            settramites.add(new TramiteInfo("Trámite 1", "522"));
            tramites.put("59", settramites);
            settramites = new HashSet<TramiteInfo>();
            settramites.add(new TramiteInfo("Trámite 1", "245"));
            tramites.put("60", settramites);
%>
<p>
    Pregunta 7: Por favor capture el porcentaje de las actividades del trámite, que sea soportado por TIC.<br>
    Pregunta 8: Por favor capture la cantidad anual de trámites que se realizan para cada uno de los Trámites de Alto Impacto.<br>
    Pregunta 9:  Considerando los Costos Totales de Servicios de Aplicaciones para la Institución, por favor estime el % de esos Costos que son asignables a cada trámite.<br>
    Pregunta 10: Considerando los Costos Totales de Servicios de Infraestructura para la Institución, por favor estime el % de esos Costos que son asignables a cada trámite.<br>
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
    String.prototype.startsWith = function(str)
    {
        return (this.match("^"+str)==str)
    }
    function calcula(forma)
    {
        var x=forma;
        var p_tramite_apoyado_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            
            if(name.startsWith('p_tramite_apoyado_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    p_tramite_apoyado_+=parseInt(value);
                }
            }
        }
        forma.t_tramite_apoyado_.value=p_tramite_apoyado_;

        var p_tramite_numero_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_tramite_numero_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    p_tramite_numero_+=parseInt(value);
                }
            }
        }
        forma.t_tramite_numero_.value=p_tramite_numero_;


        var p_aplicacion_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_aplicacion_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    p_aplicacion_+=parseInt(value);
                }
            }
        }
        forma.t_aplicacion_.value=p_aplicacion_;

        var p_infra_=0;
        for (var i=0;i<x.length;i++)
        {
            var name=x.elements[i].name;
            if(name.startsWith('p_infra_'))
            {
                var value=x.elements[i].value;
                if(value)
                {
                    p_infra_+=parseInt(value);
                }
            }
        }
        forma.t_infra_.value=p_infra_;      
    }
    function valida(forma)
    {
        calcula(forma);
        var t_tramite_apoyado_=forma.t_tramite_apoyado_.value;
        if(parseInt(t_tramite_apoyado_)>100)
        {
            alert('El % TOTAL del Trámite apoyado por TIC no puede ser mayor a 100%');
            return;
        }
        if(parseInt(t_tramite_apoyado_)<100)
        {
            alert('El % TOTAL del Trámite apoyado por TIC no puede ser menor a 100%');
            return;
        }
        
        
        
        var t_aplicacion_=forma.t_aplicacion_.value;
        if(parseInt(t_aplicacion_)>100)
        {
            alert('El % TOTAL de Costos de Servicio de Aplicación no puede ser mayor a 100%');
            return;
        }
        if(parseInt(t_aplicacion_)<100)
        {
            alert('El % TOTAL de Costos de Servicio de Aplicación no puede ser menor a 100%');
            return;
        }

        var t_infra_=forma.t_infra_.value;
        if(parseInt(t_infra_)>100)
        {
            alert('El % TOTAL de Costos de Servicio de Infraestructura no puede ser mayor a 100%');
            return;
        }
        if(parseInt(t_infra_)<100)
        {
            alert('El % TOTAL de de Costos de Servicio de Infraestructura no puede ser menor a 100%');
            return;
        }


        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="8">
    <input type="hidden" name="from" value="7">
    <table>
        <legend>COSTO DE LOS SERVICIOS (TRAMITES) DE ALTO IMPACTO</legend>
        <th>
            Unidad Sustantiva
        </th>
        <th>
            Trámite de Alto Impacto
        </th>
        <th>
            % del Trámite apoyado por TIC
        </th>
        <th>
            Número de Trámites Anuales
        </th>
        <th>
            % de Costos de Servicio de Aplicación
        </th>
        <th>
            % de Costos de Servicio de Infraestructura
        </th>       
        <%
                    for (String clave : unidades.keySet())
                    {
                        String nombre = unidades.get(clave);
                        Set<TramiteInfo> ctramite = tramites.get(clave);
                        for (TramiteInfo tramite : ctramite)
                        {
                            String nameTramite = tramite.title;
                            String id = tramite.id;
        %>
        <tr>
            <td>
                <p><%=nombre%></p>
                <input type="hidden" name="title_<%=clave%>" value="<%=nombre%>">
            </td>
            <td>
                <p><%=nameTramite%></p>
                <input type="hidden" name="title_tramite_<%=id%>" value="<%=nameTramite%>">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_tramite_apoyado_<%=id%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_tramite_numero_<%=id%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_<%=id%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_infra_<%=id%>" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            
        </tr>
        <%
                        }


                    }
        %>
        <tr>
            <td>
                <p>&nbsp;</p>
                <input type="hidden" name="title_" value="">
            </td>
            <td>
                <p>Todas los demás</p>
                <input type="hidden" name="title_tramite_" value="Todas los demás">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_tramite_apoyado_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_tramite_numero_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_infra_" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
           
        </tr>
        <tr>
            <td>
                <p>&nbsp;</p>
                <input type="hidden" name="title_" value="">
            </td>
            <td>
                <p>TOTAL</p>
                <input type="hidden" name="title_tramite_" value="Todas los demás">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_tramite_apoyado_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_tramite_numero_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_aplicacion_" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="t_infra_" disabled>
            </td>
          
        </tr>
        <tr>
            <td colspan="5" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>