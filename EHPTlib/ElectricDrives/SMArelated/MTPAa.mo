within EHPTlib.ElectricDrives.SMArelated;
model MTPAa "MTPA logic for a generic (anisotropic) machine"
  // Non-Ascii Symbol to cause UTF-8 saving by Dymola: €
  parameter Modelica.Units.SI.Current Ipm=1.5 "Permanent magnet current";
  parameter Integer pp = 1 "Pole pairs";
  parameter Modelica.Units.SI.Resistance Rs=0.02 "Stator resistance";
  parameter Modelica.Units.SI.Inductance Ld=0.4
    "Basic direct-axis inductance";
  parameter Modelica.Units.SI.Inductance Lq=1.1
    "Basic quadrature-axis inductance";
  parameter Modelica.Units.SI.Voltage Umax=100
    "Max rms voltage per phase to the motor";
protected
  parameter Modelica.Units.SI.Voltage UmaxPk=sqrt(2)*Umax
    "nominal voltage (peak per phase)";
  //The following voltage Ulimi is set to be equal to Udc without margins
  //since this model implementation allows it. In pcactice, obviously
  //some safety coefficient will be included since the voltage control is not
  // "perfect" and instantaneous
public
  Modelica.Units.SI.Voltage Ulim=min(uDC/sqrt(3), UmaxPk)
    "tensione limite (fase-picco) fa attivare il deflussaggio;";
  Modelica.Units.SI.Angle gammaFF(start=0);
  Modelica.Units.SI.Angle gammaStar(start=0);
  //  Real Is "corrente rapportata al valore nominale (es. rms/rms)";
  Modelica.Units.SI.Voltage Vd;
  Modelica.Units.SI.Voltage Vq;
  Modelica.Units.SI.Current IdFF
    "Id FullFlux (i.e. before flux weaking evalation)";
  Modelica.Units.SI.Current IqFF
    "Iq FullFlux (i.e. before flux weaking evalation)";
  Modelica.Units.SI.Voltage VdFF
    "Vd FullFlux (i.e. before flux weaking evalation)";
  Modelica.Units.SI.Voltage VqFF
    "Vq FullFlux (i.e. before flux weaking evalation)";
  Modelica.Units.SI.Current IparkFF(start=0)
    "Ipark amplitude FullFlux (i.e. before flux weaking evalation)";
  Modelica.Units.SI.Voltage VparkFF
    "Vpark amplitude FullFlux (i.e. before flux weaking evalation)";
  //  Real Ipark(start = 70) "Ipark amplitude (=sqrt(Id^2+Iq^2))";
  Modelica.Units.SI.Voltage Vpark "Vpark amplitude (=sqrt(Vd^2+Vq^2))";
  Modelica.Units.SI.Torque T1 "Torque due to PM field";
  Modelica.Units.SI.Torque T2
    "Torque due to anisotropy (reluctance torque)";
  Modelica.Units.SI.AngularVelocity w=pp*wMech;
  Real weakening;
  //weakening should be boolean. It is assumed to be real because otherwise this
  //model will not work under OpenModelica 1.9.2.
protected
  parameter Real Psi = Ipm * Ld "psi=Ipm*Ld";
public
  Modelica.Blocks.Interfaces.RealInput torqueReq annotation (
    Placement(transformation(extent = {{-140, 40}, {-100, 80}}), iconTransformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealInput wMech annotation (
    Placement(transformation(extent = {{-140, -80}, {-100, -40}}), iconTransformation(extent = {{-140, -80}, {-100, -40}})));
  Modelica.Blocks.Interfaces.RealOutput Id annotation (
    Placement(transformation(extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
  Modelica.Blocks.Interfaces.RealOutput Iq annotation (
    Placement(transformation(extent = {{100, -70}, {120, -50}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Interfaces.RealInput uDC "DC voltage" annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}}), iconTransformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealOutput Ipark annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 110}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
equation
  //Computations with full flux.
  //The following two equations determine IparkFF and gammaFF:
  0 = (-Psi * sin(gammaFF)) + (Lq - Ld) * IparkFF * cos(2 * gammaFF);
  torqueReq = 1.5 * pp * (Psi * IparkFF * cos(gammaFF) + (Lq - Ld) / 2 * IparkFF ^ 2 * sin(2 * gammaFF));
  //Computation of  Id, Iq, Vd, Vq, V
  IdFF = -IparkFF * sin(gammaFF);
  IqFF = IparkFF * cos(gammaFF);
  VdFF = Rs * IdFF - w * Lq * IqFF;
  VqFF = Rs * IqFF + w * (Psi + Ld * IdFF);
  VparkFF = max(1e-12,sqrt(VdFF ^ 2 + VqFF ^ 2));
if VparkFF < Ulim then
    weakening = 0;
    //weakening should be boolean. It is assumed to be real because otherwise this
    //model will not work under OpenModelica 1.9.2.
    0 = (-Psi * sin(gammaStar)) + (Lq - Ld) * IparkFF * cos(2 * gammaStar);
    Id = IdFF;
    Iq = IqFF;
    Vd = VdFF;
    Vq = VqFF;
    Vpark = VparkFF;
  else
    weakening = 1;
    //weakening should be boolean. It is assumed to be real because otherwise this
    //model will not work under OpenModelica 1.9.2.
    Id = -Ipark * sin(gammaStar);
    Iq = Ipark * cos(gammaStar);
    Vd = Rs * Id - w * Lq * Iq;
    Vq = Rs * Iq + w * (Psi + Ld * Id);
    Vpark = sqrt(Vd ^ 2 + Vq ^ 2);
    Vpark = Ulim;
    //   gammaFilt+tauFilt*der(gammaFilt)=gammaStar;
  end if;
  //  T1 = 1.5*pp*Psi*Ipark*cos(gammaFilt);
  //  T2 = 1.5*pp*(Lq - Ld)/2*Ipark^2*sin(2*gammaFilt);
  T1 = 1.5 * pp * Psi * Ipark * cos(gammaStar);
  T2 = 1.5 * pp * (Lq - Ld) / 2 * Ipark ^ 2 * sin(2 * gammaStar);
  torqueReq = T1 + T2;
  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1,
        grid={2,2}), graphics={Text(
                extent={{-98,-110},{102,-146}},
                lineColor={0,0,127},
                textString="%name"),Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),Text(
                extent={{-100,26},{100,-26}},
                lineColor={0,0,127},
                textString="MTPAa")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}},
    preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})));
end MTPAa;
