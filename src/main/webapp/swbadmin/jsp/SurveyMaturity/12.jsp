<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
            SWBResourceURL url = paramRequest.getActionUrl();
%>
<p>
    Pregunta 21: Por favor marque (SI/NO) las acciones significativas de la dirección de la institución que tienen como finalidad reducir o mejorar el control de los costos de TIC.
</p>
<script type="text/javascript">
    function isEmpty( inputStr ) { if ( null == inputStr || "" == inputStr ) { return true; } return false; }
    function valida(forma)
    {
        var elements=forma.r.length;
        var count=0;
        for(var i=0;i<elements;i++)
        {
            if(forma.r[i].checked)
            {
                count++;
                if(forma.r[i].value=='10')
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
                else if(forma.r[i].value=='11')
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
            }
        }
        
        if(confirm('¿Es correcta la información?'))
        {
            forma.submit();
        }

    }
</script>
<form action="<%=url%>">
    <input type="hidden" name="step" value="13">
    <input type="hidden" name="from" value="12">
    <input type="checkbox" name="r" value="1">1. Consolidación (por ejemplo, servidores, redes)<br>
    <input type="checkbox" name="r" value="2">2. Outsourcing<br>
    <input type="checkbox" name="r" value="3">3. Prácticas de Administración de Servicios como ITIL<br>
    <input type="checkbox" name="r" value="4">4. Aplicaciones comerciales disponibles en el mercado<br>
    <input type="checkbox" name="r" value="5">5. Cómputo de Nube<br>
    <input type="checkbox" name="r" value="6">6. Administración de Demanda<br>
    <input type="checkbox" name="r" value="7">7. Administración de Energía<br>
    <input type="checkbox" name="r" value="8">8. Salarios<br>
    <input type="checkbox" name="r" value="9">9. Traiga sus Propios Dispositivos / Formación de Consumidores<br>
    <input type="checkbox" name="r" value="10">10. Otro <input type="text" name="otro1" maxlength="100" size="50"><br>
    <input type="checkbox" name="r"value="11">11. Otro <input type="text" name="otro2" maxlength="100" size="50"><br>
    <input type="button" name="next" value="Siguiente" onclick="valida(this.form)">
</form>

