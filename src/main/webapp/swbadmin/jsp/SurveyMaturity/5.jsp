<%@page import="org.semanticwb.model.survey.P3"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.survey.Survey"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
            WebSite site = paramRequest.getWebPage().getWebSite();
            Survey survey = (Survey) request.getAttribute("survey");
            if (survey == null)
            {
                if (Survey.ClassMgr.getSurvey("1", site) == null)
                {
                    survey = Survey.ClassMgr.createSurvey("1", site);
                }
                else
                {
                    survey = Survey.ClassMgr.getSurvey("1", site);
                }
            }
            int totaltic=0;
            if (survey.getP3() != null)
            {
                int totalpersonal = survey.getP3().getP3_costo_total_de_personal();
                totaltic+=totalpersonal;
                int totaloutsourcing=survey.getP3().getCosto_total_de_outsourcing();
                totaltic+=totaloutsourcing;
                int totalotros=survey.getP3().getCosto_total_de_otros_costos();
                totaltic+=totalotros;
            }
            int operainfra=0;
            operainfra+=(survey.getP4().getActividades_de_Operaciones_e_Infraestructura_Costo_de_Personal()*totaltic)/100;
            operainfra+=(survey.getP4().getActividades_de_Operaciones_e_Infraestructura_Costos_de_Outsourcing()*totaltic)/100;
            operainfra+=(survey.getP4().getActividades_de_Operaciones_e_Infraestructura_Otros_Costos()*totaltic)/100;

            
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
    function calcula(forma)
    {
        var operainfra=parseInt(forma.operainfra.value);
        var p_total=0;
        var p_aplicacion=forma.p_aplicacion.value;
        if(p_aplicacion)
        {
            p_total+=parseInt(p_aplicacion);
            forma.m_aplicacion.value=formatCurrency((parseInt(p_aplicacion)*operainfra)/100);
        }

        var p_directasinfra=forma.p_directasinfra.value;
        if(p_directasinfra)
        {
            p_total+=parseInt(p_directasinfra);
            forma.m_directasinfra.value=formatCurrency((parseInt(p_directasinfra)*operainfra)/100);
        }

        var p_soporte=forma.p_soporte.value;
        if(p_soporte)
        {
            p_total+=parseInt(p_soporte);
            forma.m_soporte.value=formatCurrency((parseInt(p_soporte)*operainfra)/100);
        }

        var p_admon=forma.p_admon.value;
        if(p_admon)
        {
            p_total+=parseInt(p_admon);
            forma.m_admon.value=formatCurrency((parseInt(p_admon)*operainfra)/100);
        }
        forma.p_subtotal.value=p_total;
        forma.m_subtotal.value=formatCurrency((p_total*operainfra)/100);

        var p_desarrollo=forma.p_desarrollo.value;
        if(p_desarrollo)
        {
            p_total+=parseInt(p_desarrollo);
            forma.m_desarrollo.value=formatCurrency((parseInt(p_desarrollo)*operainfra)/100);
        }
        forma.p_total.value=p_total;
        forma.m_total.value=formatCurrency((p_total*operainfra)/100);



    }
    function currencyToint(num)
    {
        num=num.toString().replace(',','').replace('$','');
        return parseInt(num);
    }
    function formatCurrency(num) {
        num = num.toString().replace(/\$|\,/g,'');
        if(isNaN(num))
            num = "0";
        sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        cents = num%100;
        num = Math.floor(num/100).toString();
        if(cents<10)
            cents = "0" + cents;
        for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
            num = num.substring(0,num.length-(4*i+3))+','+
            num.substring(num.length-(4*i+3));
        //return (((sign)?'':'-') + '$' + num + '.' + cents);
        return (((sign)?'':'-') + '$' + num);
    }
    function valida(forma)
    {
        calcula(forma);
        if(!validaPorcentaje(forma.p_aplicacion, '% de Costos de Operaciones e Infraestructura para Actividades de Aplicaciones'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_directasinfra, '% de Costos de Operaciones e Infraestructura para Actividades de Operaciones e Infraestructura (Directas)'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_soporte, '% de Costos de Operaciones e Infraestructura para Actividades de Soporte Técnico a Usuarios'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_admon, '% de Costos de Operaciones e Infraestructura para Actividades de Gestión de TIC'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_desarrollo, '% de Costos de Operaciones e Infraestructura para Actividades de Desarrollo de Proyectos'))
        {
            return;
        }
        var p_total=forma.p_total.value;
        if(parseInt(p_total)>100)
        {
            alert('El % TOTAL DE Actividades de Operaciones e Infraestructura no puede ser mayor de 100%');
            return;
        }
        var operainfra=parseInt(forma.operainfra.value);
        var total_cap=(forma.p_total.value*operainfra)/100;
        if(operainfra!=total_cap)
        {
            alert('El TOTAL DE Actividades de Operaciones e Infraestructura no corresponde con el total capturado en la pregunta anterior '+formatCurrency(operainfra));
            return;
        }

        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
</script>
<p>
    Pregunta 5: Por favor anote el porcentaje de Costos de Operaciones e Infraestructura aplicable a cada una de las cinco actividades de TIC.
</p>
<form action="<%=url%>">
    <input type="hidden" name="step" value="6">
    <input type="hidden" name="from" value="5">
    <input type="hidden" name="operainfra" value="<%=operainfra%>">
    <table cellpadding="3" cellspacing="2">
        <legend>Costos de Operaciones e Infraestructura en cada Actividad del Portafolios de TIC</legend>
        <th>Portafolios de Servicios de TIC</th>
        <th>% de Costo de las Actividades de Operaciones de Infraestructura en cada actividad del Portafolios de TIC</th>
        <th>Costo de Actividades de Operaciones e Infraestructura para cada Actividad del Portafolios</th>
        <tr>
            <td>
                Actividades de Aplicaciones
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_aplicacion" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Actividades Directas de Servicio a Infraestructura
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_directasinfra" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_directasinfra" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Actividades de Soporte a Usuarios
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_soporte" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_soporte" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Actividades de Administración de TIC
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_admon" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_admon" disabled>
            </td>
        </tr>
        <tr>
            <td>
                SUBTOTAL de Actividades no del Proyecto
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_subtotal" disabled>
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_subtotal" disabled>
            </td>
        </tr>
        <tr>
            <td>
                Actividades de Desarrollo del Proyecto
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_desarrollo" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_desarrollo" disabled>
            </td>
        </tr>
        <tr>
            <td>
                TOTAL de Actividades de Operaciones e Infraestructura
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_total" disabled>
            </td>
            <td>
                <input type="text" size="8" maxlength="8" name="m_total" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>