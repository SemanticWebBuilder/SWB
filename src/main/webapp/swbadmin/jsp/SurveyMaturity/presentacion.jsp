<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<p>MEDICION DE VALOR Y MADUREZ DE GOBIERNO DIGITAL 2012</p>
<p>CUESTIONARIO 5 ? COMPONENTE DE COSTOS</p>

<p>PRESENTACIÓN</p>

<p>La Unidad de Gobierno Digital (UGD) de la Secretaría de la Función Pública tiene entre sus atribuciones mejorar las capacidades gubernamentales; fortalecer los vínculos entre el Gobierno y los Ciudadanos; y contribuir con la generación y utilización de bienes públicos. Todo ello a través del uso y aprovechamiento de las tecnologías de información.</p>

<p>En este sentido, desde el año 2007, la UGD ha venido realizando un estudio para medir la Madurez de Gobierno Digital y detectar las áreas de oportunidad para emitir recomendaciones que ayuden particularmente a las dependencias y entidades de la Administración Pública Federal a incrementar su madurez en el uso y aprovechamiento de las Tecnologías de Información y Comunicaciones (TIC).</p>

<p>A partir del 2011 la Secretaría de la Función Pública está adoptando un nuevo Modelo de Evaluación, que busca determinar el costo de proveer servicios a la ciudadanía mediante el uso de las TIC, y correlacionarlo con el desempeño y valor generado por las mismas.</p>

<p>Esta evaluación pretende obtener elementos de juicio para diseñar, en caso de ser necesario, las mejoras a los servicios TIC; o bien, generar nuevos servicios.</p>

<p>La evaluación incorpora la valoración que realizan los responsables de las áreas de TIC, el punto de vista de las áreas usuarias y de los ciudadanos, así como el componente Costos. En ese sentido, este cuestionario se centra en evaluar el Valor Público de cada Institución, así como en la contribución que tienen las TIC para alcanzarlo y el costo que esto implica.</p>

<%
    SWBResourceURL url=paramRequest.getRenderUrl();
    url.setParameter("step", "1");
%>
<center><a href="<%=url%>">Siguiente</a></center>

