within EHPTlib.MapBased;
class Information
  extends Modelica.Icons.Information;
  annotation (
    Documentation(info = "<html>
<p>The map-based folder contains simple model whose only dynamics is due to their mechanical inertia.</p>
<p>The ice model, since implements an Internal Combustion Engine, can just deliver (never absorb) power, while the other two (&QUOT;oneFlange&QUOT; and &QUOT;twoFlange&QUOT;) simulate electric drive trains, i.e. the assembly of an electric machine and the corresponding AC/DC converter, and therefore can absorb or deliver power.</p>
<p>The input torque of the ice model is in Newton-metres, while in the other cases it is normalised: it is between -1 and +1, where -1 means maximum available torque to be absorbed, +1 to be delivered.</p>
<p>Some of the models have a special &QUOT;Conn&QUOT; version that allows interfacing with the exterior by means of an expandable connector.</p>
<p>Note that usage of expandable connectors requires to give special names to the connector&apos;s variables, and therefore the models are more specific than their Modelica.Blocks.Connectors counterparts. Therefore here the models have receives specifi names such as &QUOT;PsdGenConn&QUOT; as a replacement of OneFlange: this is aone flance component to which we added a connector and spfcific signal names.</p>
<p><br><u>Names and meaning </u>of the pre-defined quantities circulating through the connection bus in the model versions having &QUOT;Conn&QUOT; in their names.</p>
<p>The detailed meaning of different quantities are to be read in the corresponding Table in the accompanying document &QUOT;webBookCeraolo&QUOT; in its section PSD-HEV.</p>
</html>"));
end Information;
