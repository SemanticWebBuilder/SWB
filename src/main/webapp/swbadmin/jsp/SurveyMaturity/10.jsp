<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>
<p>
    Pregunta 19: Por favor marque (SI/NO) las áreas que estén impulsando fuertemente los incrementos de costos de TIC en su institución.
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
                if(forma.r[i].value=='12')
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
                        alert('Debe indicar las áreas que estén impulsando fuertemente los incrementos de costos de TIC en su institución. ');
                        forma.otro1.focus();
                        return;
                    }
                }
                else if(forma.r[i].value=='13')
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
                        alert('Debe indicar las áreas que estén impulsando fuertemente los incrementos de costos de TIC en su institución.');
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
    <input type="hidden" name="step" value="11">
    <input type="hidden" name="from" value="10">
    <input type="checkbox" name="r" value="1">1. Requerimientos de Áreas Sustantivas<br>
    <input type="checkbox" name="r" value="2">2. Renovaciones Tecnológicas<br>
    <input type="checkbox" name="r" value="3">3. Seguridad<br>
    <input type="checkbox" name="r" value="4">4. Salarios de TI<br>
    <input type="checkbox" name="r" value="5">5. Cumplimiento<br>
    <input type="checkbox" name="r" value="6">6. Movilidad<br>
    <input type="checkbox" name="r" value="7">7. Recuperación de Desastres / Planeación y Prueba de Continuidad de Negocios<br>
    <input type="checkbox" name="r" value="8">8. ERP<br>
    <input type="checkbox" name="r" value="9">9. Conexiones de Red  / Inalámbrica<br>
    <input type="checkbox" name="r" value="10">10. Energía<br>
    <input type="checkbox" name="r" value="11">11. Traiga sus Propios Dispositivos (Bring Your Own Devices ? BYOD) / Formación de Consumidores<br>
    <input type="checkbox" name="r" value="12">12. Otro <input type="text" name="otro1" maxlength="100" size="50"><br>
    <input type="checkbox" name="r" value="13">13. Otro <input type="text" name="otro2" maxlength="100" size="50"><br>
    <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
</form>
