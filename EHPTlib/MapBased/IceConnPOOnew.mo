within EHPTlib.MapBased;
model IceConnPOOnew
  "Simple map-based ice model with connector; follows power request with ON-OFF"
  extends Partial.PartialIcePnew(toGramsPerkWh(fileName = mapsFileName));
  import Modelica.Constants.*;
  // rad/s
//  parameter String mapsFileName = "maps.txt" "Name of the file containing data maps (names: maxIceTau, specificCons, optiSpeed)";
  SupportModels.ConnectorRelated.Conn conn annotation (
    Placement(visible = true, transformation(extent = {{-20, -78}, {20, -118}}, rotation = 0), iconTransformation(extent = {{-20, -78}, {20, -118}}, rotation = 0)));
equation
  connect(feedback.u1, conn.icePowRef) annotation (
    Line(points={{-92,58},{-92,58},{-92,-98},{0,-98}},          color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(icePow.power, conn.icePowDel) annotation (Line(points={{68,63},{68,63},
          {68,6},{78,6},{78,-98},{0,-98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(w.w, conn.iceW) annotation (
    Line(points = {{58, 25}, {58, 25}, {58, 6}, {58, -98}, {0, -98}}, color = {0, 0, 127}),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(switch1.u2, conn.iceON) annotation (Line(points={{-4,-52},{-46,-52},{
          -46,-88},{0,-88},{0,-98}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 80}})),
    Documentation(info = "<html>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Simple map-based ICE model for power-split power trains - with connector</span></b> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This is an evolution of IceConnP: ON/OFF control is added though an hysteresis block. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For its general operation see the description of IceConnP.</span></p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2}), graphics={  Text(origin = {34, -1}, lineColor = {255, 255, 255}, extent = {{32, -19}, {-48, 29}}, textString = "OO")}));
end IceConnPOOnew;
