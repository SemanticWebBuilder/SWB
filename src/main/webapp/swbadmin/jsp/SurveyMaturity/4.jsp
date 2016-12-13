<%@page import="org.semanticwb.model.survey.P3"%>
<%@page import="org.semanticwb.model.survey.Survey"%>
<%@page import="org.semanticwb.model.WebSite"%>
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

            if (survey.getP3() == null)
            {
                P3 p3 = P3.ClassMgr.createP3(site);
                survey.setP3(p3);
            }
            int totalpersonal = 0;
            int totaloutsourcing = 0;
            int totalotros = 0;
            int totaltic = 0;
            if (survey.getP3() != null)
            {
                totalpersonal = survey.getP3().getP3_costo_total_de_personal();
                totaltic+=totalpersonal;
                totaloutsourcing=survey.getP3().getCosto_total_de_outsourcing();
                totaltic+=totaloutsourcing;
                totalotros=survey.getP3().getCosto_total_de_otros_costos();
                totaltic+=totalotros;
            }
%>
<script type="text/javascript">
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
    function actializaAplicacion(forma)
    {
        var personal=parseInt(forma.personal.value);
        var outsourcing=parseInt(forma.outsourcing.value);
        var otros=parseInt(forma.otros.value);
        var p_aplicacion_personal=forma.p_aplicacion_personal.value;
        if(p_aplicacion_personal)
        {
            var m_aplicacion_personal=(personal*parseInt(p_aplicacion_personal))/100;
            forma.m_aplicacion_personal.value=m_aplicacion_personal;
        }

        var p_aplicacion_out=forma.p_aplicacion_out.value;
        if(p_aplicacion_out)
        {
            var m_aplicacion_out=(outsourcing*parseInt(p_aplicacion_out))/100;
            forma.m_aplicacion_out.value=m_aplicacion_out;
        }

        var p_aplicacion_otros=forma.p_aplicacion_otros.value;
        if(p_aplicacion_otros)
        {
            var m_aplicacion_otros=(otros*parseInt(p_aplicacion_otros))/100;
            forma.m_aplicacion_otros.value=m_aplicacion_otros;
        }
        var m_aplicacion=0;
        if(forma.m_aplicacion_personal.value)
        {
            m_aplicacion+=parseInt(forma.m_aplicacion_personal.value);
        }
        if(forma.m_aplicacion_out.value)
        {
            m_aplicacion+=parseInt(forma.m_aplicacion_out.value);
        }
        if(forma.m_aplicacion_otros.value)
        {
            m_aplicacion+=parseInt(forma.m_aplicacion_otros.value);
        }
        forma.t_aplicacion.value=m_aplicacion;
    }

    function actializaDesarrollo(forma)
    {
        var personal=parseInt(forma.personal.value);
        var outsourcing=parseInt(forma.outsourcing.value);
        var otros=parseInt(forma.otros.value);
        var p_desarrollo_personal=forma.p_desarrollo_personal.value;
        if(p_desarrollo_personal)
        {
            var m_desarrollo_personal=(personal*parseInt(p_desarrollo_personal))/100;
            forma.m_desarrollo_personal.value=m_desarrollo_personal;
        }

        var p_desarrollo_out=forma.p_desarrollo_out.value;
        if(p_desarrollo_out)
        {
            var m_desarrollo_out=(outsourcing*parseInt(p_desarrollo_out))/100;
            forma.m_desarrollo_out.value=m_desarrollo_out;
        }

        var p_desarrollo_otros=forma.p_desarrollo_otros.value;
        if(p_desarrollo_otros)
        {
            var m_desarrollo_otros=(otros*parseInt(p_desarrollo_otros))/100;
            forma.m_desarrollo_otros.value=m_desarrollo_otros;
        }
        var m_desarrollo=0;
        if(forma.m_desarrollo_personal.value)
        {
            m_desarrollo+=parseInt(forma.m_desarrollo_personal.value);
        }
        if(forma.m_desarrollo_out.value)
        {
            m_desarrollo+=parseInt(forma.m_desarrollo_out.value);
        }
        if(forma.m_desarrollo_otros.value)
        {
            m_desarrollo+=parseInt(forma.m_desarrollo_otros.value);
        }
        forma.t_desarrollo.value=m_desarrollo;
    }

    function actializaOperacion(forma)
    {
        var personal=parseInt(forma.personal.value);
        var outsourcing=parseInt(forma.outsourcing.value);
        var otros=parseInt(forma.otros.value);

        var p_operaciones_personal=forma.p_operaciones_personal.value;
        if(p_operaciones_personal)
        {
            var m_operaciones_personal=(personal*parseInt(p_operaciones_personal))/100;
            forma.m_operaciones_personal.value=m_operaciones_personal;
        }

        var p_operaciones_out=forma.p_operaciones_out.value;
        if(p_operaciones_out)
        {
            var m_operaciones_out=(outsourcing*parseInt(p_operaciones_out))/100;
            forma.m_operaciones_out.value=m_operaciones_out;
        }

        var p_operaciones_otros=forma.p_operaciones_otros.value;
        if(p_operaciones_otros)
        {
            var m_operaciones_otros=(otros*parseInt(p_operaciones_otros))/100;
            forma.m_operaciones_otros.value=m_operaciones_otros;
        }
        var m_operaciones=0;
        if(forma.m_operaciones_personal.value)
        {
            m_operaciones+=parseInt(forma.m_operaciones_personal.value);
        }
        if(forma.m_operaciones_out.value)
        {
            m_operaciones+=parseInt(forma.m_operaciones_out.value);
        }
        if(forma.m_operaciones_otros.value)
        {
            m_operaciones+=parseInt(forma.m_operaciones_otros.value);
        }
        forma.t_operaciones.value=m_operaciones;
    }

    function actializaSoporte(forma)
    {
        var personal=parseInt(forma.personal.value);
        var outsourcing=parseInt(forma.outsourcing.value);
        var otros=parseInt(forma.otros.value);

        var p_soporte_personal=forma.p_soporte_personal.value;
        if(p_soporte_personal)
        {
            var m_soporte_personal=(personal*parseInt(p_soporte_personal))/100;
            forma.m_soporte_personal.value=m_soporte_personal;
        }

        var p_soporte_out=forma.p_soporte_out.value;
        if(p_soporte_out)
        {
            var m_soporte_out=(outsourcing*parseInt(p_soporte_out))/100;
            forma.m_soporte_out.value=m_soporte_out;
        }

        var p_soporte_otros=forma.p_soporte_otros.value;
        if(p_soporte_otros)
        {
            var m_soporte_otros=(otros*parseInt(p_soporte_otros))/100;
            forma.m_soporte_otros.value=m_soporte_otros;
        }
        var m_soporte=0;
        if(forma.m_soporte_personal.value)
        {
            m_soporte+=parseInt(forma.m_soporte_personal.value);
        }
        if(forma.m_soporte_out.value)
        {
            m_soporte+=parseInt(forma.m_soporte_out.value);
        }
        if(forma.m_soporte_otros.value)
        {
            m_soporte+=parseInt(forma.m_soporte_otros.value);
        }
        forma.t_soporte.value=m_soporte;
    }
    function actializaAdmon(forma)
    {
        var personal=parseInt(forma.personal.value);
        var outsourcing=parseInt(forma.outsourcing.value);
        var otros=parseInt(forma.otros.value);

        var p_admon_personal=forma.p_admon_personal.value;
        if(p_admon_personal)
        {
            var m_admon_personal=(personal*parseInt(p_admon_personal))/100;
            forma.m_admon_personal.value=m_admon_personal;
        }

        var p_admon_out=forma.p_admon_out.value;
        if(p_admon_out)
        {
            var m_admon_out=(outsourcing*parseInt(p_admon_out))/100;
            forma.m_admon_out.value=m_admon_out;
        }

        var p_admon_otros=forma.p_admon_otros.value;
        if(p_admon_otros)
        {
            var m_admon_otros=(otros*parseInt(p_admon_otros))/100;
            forma.m_admon_otros.value=m_admon_otros;
        }
        var m_admon=0;
        if(forma.m_admon_personal.value)
        {
            m_admon+=parseInt(forma.m_admon_personal.value);
        }
        if(forma.m_admon_out.value)
        {
            m_admon+=parseInt(forma.m_admon_out.value);
        }
        if(forma.m_admon_otros.value)
        {
            m_admon+=parseInt(forma.m_admon_otros.value);
        }
        forma.t_admon.value=m_admon;
    }
    function actializaSubtotal(forma)
    {        
        var p_subtotal_personal=0;
        if(forma.p_aplicacion_personal.value)
        {
            p_subtotal_personal+=parseInt(forma.p_aplicacion_personal.value);
        }
        if(forma.p_operaciones_personal.value)
        {
            p_subtotal_personal+=parseInt(forma.p_operaciones_personal.value);
        }
        if(forma.p_soporte_personal.value)
        {
            p_subtotal_personal+=parseInt(forma.p_soporte_personal.value);
        }
        if(forma.p_admon_personal.value)
        {
            p_subtotal_personal+=parseInt(forma.p_admon_personal.value);
        }
        forma.p_subtotal_personal.value=p_subtotal_personal;


        var m_subtotal_personal=0;
        if(forma.m_aplicacion_personal.value)
        {
            m_subtotal_personal+=parseInt(forma.m_aplicacion_personal.value);
        }
        if(forma.m_operaciones_personal.value)
        {
            m_subtotal_personal+=parseInt(forma.m_operaciones_personal.value);
        }
        if(forma.m_soporte_personal.value)
        {
            m_subtotal_personal+=parseInt(forma.m_soporte_personal.value);
        }
        if(forma.m_admon_personal.value)
        {
            m_subtotal_personal+=parseInt(forma.m_admon_personal.value);
        }
        forma.m_subtotal_personal.value=m_subtotal_personal;



        var p_subtotal_out=0;
        if(forma.p_aplicacion_out.value)
        {
            p_subtotal_out+=parseInt(forma.p_aplicacion_out.value);
        }
        if(forma.p_operaciones_out.value)
        {
            p_subtotal_out+=parseInt(forma.p_operaciones_out.value);
        }
        if(forma.p_soporte_out.value)
        {
            p_subtotal_out+=parseInt(forma.p_soporte_out.value);
        }
        if(forma.p_admon_out.value)
        {
            p_subtotal_out+=parseInt(forma.p_admon_out.value);
        }
        forma.p_subtotal_out.value=p_subtotal_out;


        var m_subtotal_out=0;
        if(forma.m_aplicacion_out.value)
        {
            m_subtotal_out+=parseInt(forma.m_aplicacion_out.value);
        }
        if(forma.m_operaciones_out.value)
        {
            m_subtotal_out+=parseInt(forma.m_operaciones_out.value);
        }
        if(forma.m_soporte_out.value)
        {
            m_subtotal_out+=parseInt(forma.m_soporte_out.value);
        }
        if(forma.m_admon_out.value)
        {
            m_subtotal_out+=parseInt(forma.m_admon_out.value);
        }
        forma.m_subtotal_out.value=m_subtotal_out;



        var p_subtotal_otros=0;
        if(forma.p_aplicacion_otros.value)
        {
            p_subtotal_otros+=parseInt(forma.p_aplicacion_otros.value);
        }
        if(forma.p_operaciones_otros.value)
        {
            p_subtotal_otros+=parseInt(forma.p_operaciones_otros.value);
        }
        if(forma.p_soporte_otros.value)
        {
            p_subtotal_otros+=parseInt(forma.p_soporte_otros.value);
        }
        if(forma.p_admon_otros.value)
        {
            p_subtotal_otros+=parseInt(forma.p_admon_otros.value);
        }
        forma.p_subtotal_otros.value=p_subtotal_otros;


        var m_subtotal_otros=0;
        if(forma.m_aplicacion_otros.value)
        {
            m_subtotal_otros+=parseInt(forma.m_aplicacion_otros.value);
        }
        if(forma.m_operaciones_otros.value)
        {
            m_subtotal_otros+=parseInt(forma.m_aplicacion_otros.value);
        }
        if(forma.m_soporte_otros.value)
        {
            m_subtotal_otros+=parseInt(forma.m_aplicacion_otros.value);
        }
        if(forma.m_admon_otros.value)
        {
            m_subtotal_otros+=parseInt(forma.m_aplicacion_otros.value);
        }
        forma.m_subtotal_otros.value=m_subtotal_otros;

        var m_subtotal=0;
        if(forma.t_aplicacion.value)
        {
            m_subtotal+=parseInt(forma.t_aplicacion.value);
        }
        if(forma.t_operaciones.value)
        {
            m_subtotal+=parseInt(forma.t_operaciones.value);
        }
        if(forma.t_soporte.value)
        {
            m_subtotal+=parseInt(forma.t_soporte.value);
        }
        if(forma.m_subtotal_personal.value)
        {
            m_subtotal+=parseInt(forma.t_admon.value);
        }
        forma.m_subtotal.value=m_subtotal;

        
    }
    function calculaTotal(forma)
    {
        var total_p_personal=0;
        if(forma.p_subtotal_personal.value)
        {
            total_p_personal+=parseInt(forma.p_subtotal_personal.value);
        }
        if(forma.p_desarrollo_personal.value)
        {
            total_p_personal+=parseInt(forma.p_desarrollo_personal.value);
        }
        forma.total_p_personal.value=total_p_personal;

        var total_p_out=0;
        if(forma.p_subtotal_out.value)
        {
            total_p_out+=parseInt(forma.p_subtotal_out.value);
        }
        if(forma.p_desarrollo_out.value)
        {
            total_p_out+=parseInt(forma.p_desarrollo_out.value);
        }
        forma.total_p_out.value=total_p_out;


        var total_p_otros=0;
        if(forma.p_subtotal_otros.value)
        {
            total_p_otros+=parseInt(forma.p_subtotal_otros.value);
        }
        if(forma.p_desarrollo_otros.value)
        {
            total_p_otros+=parseInt(forma.p_desarrollo_otros.value);
        }
        forma.total_p_otros.value=total_p_otros;



        var total_m_personal=0;
        if(forma.m_subtotal_personal.value)
        {
            total_m_personal+=parseInt(forma.m_subtotal_personal.value);
        }
        if(forma.m_desarrollo_personal.value)
        {
            total_m_personal+=parseInt(forma.m_desarrollo_personal.value);
        }
        forma.total_m_personal.value=total_m_personal;

        var total_m_out=0;
        if(forma.m_subtotal_out.value)
        {
            total_m_out+=parseInt(forma.m_subtotal_out.value);
        }
        if(forma.m_desarrollo_out.value)
        {
            total_m_out+=parseInt(forma.m_desarrollo_out.value);
        }
        forma.total_m_out.value=total_m_out;


        var total_m_otros=0;
        if(forma.m_subtotal_otros.value)
        {
            
            total_m_otros+=parseInt(forma.m_subtotal_otros.value);
        }
        if(forma.m_desarrollo_otros.value)
        {
            
            total_m_otros+=parseInt(forma.m_desarrollo_otros.value);
        }
        forma.total_m_otros.value=total_m_otros;

        var total=0;
        if(forma.m_subtotal.value)
        {
            total+=parseInt(forma.m_subtotal.value);
        }
        if(forma.t_desarrollo.value)
        {
            total+=parseInt(forma.t_desarrollo.value);
        }
        forma.total.value=total;



    }
    function calcula(forma)
    {
        actializaAplicacion(forma);
        actializaOperacion(forma);
        actializaSoporte(forma);
        actializaAdmon(forma);
        actializaSubtotal(forma);
        calculaTotal(forma);
        actializaDesarrollo(forma);
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
    function valida(forma)
    {
        calcula(forma);
        if(!validaPorcentaje(forma.p_aplicacion_personal,'% del Costo de Personal de las Actividades de aplicación'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_aplicacion_out,'% de Costos de Outsourcing de las Actividades de aplicación'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_aplicacion_otros,'% de Otros Costos de las Actividades de aplicación'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_operaciones_personal,'% del Costo de Personal de las Actividades de Operaciones e Infraestructura'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_operaciones_out,'% de Costos de Outsourcing de las Actividades de Operaciones e Infraestructura'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_operaciones_otros,'% de Otros Costos de las Actividades de Operaciones e Infraestructura'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_soporte_personal,'% del Costo de Personal de las Actividades de Soporte a Usuarios'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_soporte_out,'% del Costo de Outsourcing de las Actividades de Soporte a Usuarios'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_soporte_otros,'% de Otros Costos de las Actividades de Soporte a Usuarios'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_admon_personal,'% del Costo de Personal de las Actividades de Administración de TIC'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_admon_out,'% del Costo de Outsourcing de las Actividades de Administración de TIC'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_admon_otros,'% de Otros Costos de las Actividades de Administración de TIC'))
        {
            return;
        }

        if(!validaPorcentaje(forma.p_desarrollo_personal,'% del Costo de Personal de las Actividades de Desarrollo de Proyecto'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_desarrollo_out,'% del Costo de Outsourcing de las Actividades de Desarrollo de Proyecto'))
        {
            return;
        }
        if(!validaPorcentaje(forma.p_desarrollo_otros,'% de Otros Costos de las Actividades de Desarrollo de Proyecto'))
        {
            return;
        }

        var total_p_personal=forma.total_p_personal.value;
        if(parseInt(total_p_personal)>100)
        {
            alert('El % TOTAL DE TODAS Las Actividades TIC para personal no puede ser mayor a 100%');
            return;
        }
        if(parseInt(total_p_personal)<100)
        {
            alert('El % TOTAL DE TODAS Las Actividades TIC para personal no puede ser menor a 100%');
            return;
        }
        var total_p_out=forma.total_p_out.value;
        if(parseInt(total_p_out)>100)
        {
            alert('El % TOTAL DE TODAS Las Actividades TIC para Outsourcing no puede ser mayor a 100%');
            return;
        }
        if(parseInt(total_p_out)<100)
        {
            alert('El % TOTAL DE TODAS Las Actividades TIC para Outsourcing no puede ser menor a 100%');
            return;
        }
        var total_p_otros=forma.total_p_otros.value;
        if(parseInt(total_p_otros)>100)
        {
            alert('El % TOTAL DE TODAS Las Actividades TIC para Otros costos no puede ser mayor a 100%');
            return;
        }
        if(parseInt(total_p_otros)<100)
        {
            alert('El % TOTAL DE TODAS Las Actividades TIC para Otros costos no puede ser menor a 100%');
            return;
        }
        //var total_cap=parseInt(forma.total.value);
        /*var totaltic=parseInt(forma.totaltic.value);
        if(total_cap!=totaltic)
        {
            alert('El TOTAL DE TODAS Las Actividades TIC no corresponde con el total indicado en la pregunta anterior '+formatCurrency(totaltic));
            return;
        }*/

        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }
    }
</script>
<p>Pregunta 4: Por favor capture él % de cada uno de estos tres costos, que sean aplicables a cada Área de Actividades.</p>
<form action="<%=url%>">
    <input type="hidden" name="step" value="5">
    <input type="hidden" name="from" value="4">
    <input type="hidden" name="personal" value="<%=totalpersonal%>">
    <input type="hidden" name="outsourcing" value="<%=totaloutsourcing%>">
    <input type="hidden" name="otros" value="<%=totalotros%>">
    <input type="hidden" name="totaltic" value="<%=totaltic%>"> <!--  El total debe coincidir con este valor-->
    <table>
        <title>COSTOS DE ACTIVIDADES DE TIC</title>
        <th>Actividades del Portafolios de TIC</th>
        <th>% del Costo de Personal en cada Área de Actividad</th>
        <th>% de Costos de Outsourcing en cada Área de Actividad</th>
        <th>% de Otros Costos en cada Área de Actividad</th>
        <th>Costo de Personal</th>
        <th>Costo de Outsourcing</th>
        <th>Otros Costos</th>
        <th>Costo Directo de la Actividad del Portafolios de TIC</th>
        <tr>
            <td>
                Actividades de aplicación
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_personal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_out" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_aplicacion_otros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_aplicacion_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_aplicacion_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_aplicacion_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="t_aplicacion" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="7">&nbsp;</td>
        </tr>

        <tr>
            <td>
                Actividades de Operaciones e Infraestructura
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_operaciones_personal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_operaciones_out" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_operaciones_otros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_operaciones_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_operaciones_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_operaciones_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="t_operaciones" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="7">&nbsp;</td>
        </tr>
        <tr>
            <td>
                Actividades de Soporte a Usuarios
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_soporte_personal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_soporte_out" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_soporte_otros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_soporte_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_soporte_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_soporte_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="t_soporte" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="7">&nbsp;</td>
        </tr>
        <tr>
            <td>
                Actividades de Administración de TIC
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_admon_personal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="4" name="p_admon_out" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_admon_otros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_admon_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_admon_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_admon_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="t_admon" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="7">&nbsp;</td>
        </tr>
        <tr>
            <td>
                SUBTOTAL de Actividades no de Proyecto
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_subtotal_personal" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_subtotal_out" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_subtotal_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_subtotal_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_subtotal_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_subtotal_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_subtotal" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="7">&nbsp;</td>
        </tr>
        <tr>
            <td>
                Actividades de Desarrollo de Proyecto
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_desarrollo_personal" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_desarrollo_out" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="p_desarrollo_otros" onkeypress="return isNumberKey(event,this.form)" onchange="calcula(this.form)">
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_desarrollo_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_desarrollo_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="m_desarrollo_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="t_desarrollo" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="7">&nbsp;</td>
        </tr>
        <tr>
            <td>
                TOTAL DE TODAS Las Actividades TIC
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="total_p_personal" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="total_p_out" disabled>
            </td>
            <td>
                <input type="text" size="3" maxlength="3" name="total_p_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="total_m_personal" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="total_m_out" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="total_m_otros" disabled>
            </td>
            <td>
                <input type="text" size="6" maxlength="6" name="total" disabled>
            </td>
        </tr>
        <tr>
            <td colspan="8" align="center">
                <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
            </td>
        </tr>
    </table>
</form>






