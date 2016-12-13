<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<p>MEDICION DE VALOR Y MADUREZ DE GOBIERNO DIGITAL 2012</p>
<p>CUESTIONARIO 5 ? COMPONENTE DE COSTOS</p>

<p>PRESENTACI�N</p>

<p>La Unidad de Gobierno Digital (UGD) de la Secretar�a de la Funci�n P�blica tiene entre sus atribuciones mejorar las capacidades gubernamentales; fortalecer los v�nculos entre el Gobierno y los Ciudadanos; y contribuir con la generaci�n y utilizaci�n de bienes p�blicos. Todo ello a trav�s del uso y aprovechamiento de las tecnolog�as de informaci�n.</p>

<p>En este sentido, desde el a�o 2007, la UGD ha venido realizando un estudio para medir la Madurez de Gobierno Digital y detectar las �reas de oportunidad para emitir recomendaciones que ayuden particularmente a las dependencias y entidades de la Administraci�n P�blica Federal a incrementar su madurez en el uso y aprovechamiento de las Tecnolog�as de Informaci�n y Comunicaciones (TIC).</p>

<p>A partir del 2011 la Secretar�a de la Funci�n P�blica est� adoptando un nuevo Modelo de Evaluaci�n, que busca determinar el costo de proveer servicios a la ciudadan�a mediante el uso de las TIC, y correlacionarlo con el desempe�o y valor generado por las mismas.</p>

<p>Esta evaluaci�n pretende obtener elementos de juicio para dise�ar, en caso de ser necesario, las mejoras a los servicios TIC; o bien, generar nuevos servicios.</p>

<p>La evaluaci�n incorpora la valoraci�n que realizan los responsables de las �reas de TIC, el punto de vista de las �reas usuarias y de los ciudadanos, as� como el componente Costos. En ese sentido, este cuestionario se centra en evaluar el Valor P�blico de cada Instituci�n, as� como en la contribuci�n que tienen las TIC para alcanzarlo y el costo que esto implica.</p>

<%
    SWBResourceURL url=paramRequest.getRenderUrl();
    url.setParameter("step", "1");
%>
<center><a href="<%=url%>">Siguiente</a></center>

