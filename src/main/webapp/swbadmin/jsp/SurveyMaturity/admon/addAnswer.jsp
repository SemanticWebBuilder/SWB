
<script type="text/javascript">
    function closeDialogAddAnswer()
    {
        dijit.byId("dialogaddAnswer").hide();
    }
    function saveDialogAddAnswer()
    {
        dijit.byId("dialogaddAnswer").hide();
    }
</script>
<h1 align="center">Respuesta</h1><br>
<form action="" >
    <table>
        <tr>
            <td>
                <p>Tipo de respuesta</p>
            </td>
            <td>
                <select name="tipo">

                </select>
            </td>
            <td>
                &nbsp;
            </td>
        </tr>

        <tr>
            <td colspan="3" align="right">
                <input type="button" value="Seleccionar de banco de respuestas">
                <input type="button" value="Cancelar" onclick="closeDialogAddAnswer();">
                <input type="button" value="Guardar" onclick="saveDialogAddAnswer();">
            </td>
        </tr>
    </table>


</form>


