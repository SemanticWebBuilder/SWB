<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>
<p>
    Pregunta 20: Por favor marque (SI/NO) las áreas que sean factores significativos para disminuir los costos de TIC en su institución.
</p>
<script type="text/javascript">
    function isEmpty( inputStr ) { if ( null == inputStr || "" == inputStr ) { return true; } return false; }
    function valida(forma)
    {
        var elements=forma.r.length;
        for(var i=0;i<elements;i++)
        {
            if(forma.r[i].checked)
            {
                if(forma.r[i].value=='11')
                {
                    if(forma.otro1.value && !isEmpty(forma.otro1.value))
                    {
                        if(confirm('¿Es correcta la información?'))
                        {
                            forma.submit();
                            return;
                        }
                    }
                    else
                    {
                        alert('Debe indicar las áreas que sean factores significativos para disminuir los costos de TIC en su institución.');
                        forma.otro1.focus();
                        return;
                    }
                }
                else if(forma.r[i].value=='12')
                {
                    if(forma.otro2.value && !isEmpty(forma.otro2.value))
                    {
                        if(confirm('¿Es correcta la información?'))
                        {
                            forma.submit();
                            return;
                        }
                    }
                    else
                    {
                        alert('Debe indicar las áreas que sean factores significativos para disminuir los costos de TIC en su institución.');
                        forma.otro2.focus();
                        return;
                    }
                }
                else
                {
                    if(confirm('¿Es correcta la información?'))
                    {
                        forma.submit();
                    }
                }
            }
        }

    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="12">
    <input type="hidden" name="from" value="11">
    <input type="checkbox" name="r" value="1">1. Demandas de la Institución para Reducción de Costos de TIC<br>
    <input type="checkbox" name="r" value="2">2. Outsourcing<br>
    <input type="checkbox" name="r" value="3">3. Incrementos de Productividad<br>
    <input type="checkbox" name="r" value="4">4. Consolidación de Hardware<br>
    <input type="checkbox" name="r" value="5">5. Reducción de Costos de Tecnología<br>
    <input type="checkbox" name="r" value="6">6. Proveeduría Abierta (Open Sourcing)<br>
    <input type="checkbox" name="r" value="7">7. Retiros de Aplicaciones / Infraestructura<br>
    <input type="checkbox" name="r" value="8">8. Reducción de la Demanda de TI<br>
    <input type="checkbox" name="r" value="9">9. VOIP<br>
    <input type="checkbox" name="r" value="10">10. Traiga sus Propios Dispositivos (Bring Your Own Devices ? BYOD) / Formación de Consumidores<br>
    <input type="checkbox" name="r" value="11">11. Otro <input type="text" name="otro1" maxlength="100" size="50"><br>
    <input type="checkbox" name="r"value="12">12. Otro <input type="text" name="otro2" maxlength="100" size="50"><br>
    <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
</form>

