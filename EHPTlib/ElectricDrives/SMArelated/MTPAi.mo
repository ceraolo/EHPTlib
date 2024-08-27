within EHPTlib.ElectricDrives.SMArelated;
model MTPAi "MTPA logic for an isotropic machine"
  // Non-Ascii Symbol to cause UTF-8 saving by Dymola: €
  //Implements block 1 of figure 11.28 of FEPE book
  import PI = Modelica.Constants.pi;
  parameter Modelica.Units.SI.Current Ipm=1.5;
  parameter Integer pp = 1 "Pole pairs";
  parameter Modelica.Units.SI.Resistance Rs "Stator resistance";
  parameter Modelica.Units.SI.Inductance Ld "Direct-axis inductance";
  parameter Modelica.Units.SI.Voltage Umax
    "Max rms voltage per phase to the motor";
protected
  parameter Modelica.Units.SI.Voltage UmaxPk=sqrt(2)*Umax
    "Nominal voltage (peak per phase)";
  //The following voltage Ulim is set to be equal to Udc without margins
  //since this model implementation allows it. In practice, obviously
  //some coefficient will be included since the voltage control is not
  // "perfect" and instantaneous
  parameter Modelica.Units.SI.MagneticFlux Psi=Ipm*Ld "psi=Ipm*Ld";
  Modelica.Units.SI.Current absI=sqrt(Id^2 + Iq^2);
public
  Modelica.Units.SI.Voltage Ulim=min(uDC/sqrt(3), UmaxPk)
    "tensione limite (fase-picco) fa attivare il deflussaggio;";
  Modelica.Units.SI.Angle gammaStar(start=0);
  //  Real Is "corrente rapportata al valore nominale (es. rms/rms)";
  Modelica.Units.SI.Voltage Vd;
  Modelica.Units.SI.Voltage Vq;
  Modelica.Units.SI.Current IdFF
    "Id FullFlux (i.e. before flux weaking evaluation)";
  Modelica.Units.SI.Current IqFF
    "Iq FullFlux (i.e. before flux weaking evaluation)";
  Modelica.Units.SI.Voltage VdFF
    "Vd FullFlux (i.e. before flux weaking evaluation)";
  Modelica.Units.SI.Voltage VqFF
    "Vq FullFlux (i.e. before flux weaking evaluation)";
  Modelica.Units.SI.Current IparkFF(start=0)
    "Ipark amplitude FullFlux (i.e. before flux weaking evaluation)";
  Modelica.Units.SI.Voltage VparkFF
    "Vpark amplitude FullFlux (i.e. before flux weaking evaluation)";
  Modelica.Units.SI.Current Ipark(start=70)
    "Ipark amplitude (=sqrt(Id^2+Iq^2))";
  Modelica.Units.SI.Voltage Vpark "Vpark amplitude (=sqrt(Vd^2+Vq^2))";
  Modelica.Units.SI.AngularVelocity w=pp*wMech;
  Real weakening;
  //weakening should be boolean. It is assumed to be real because otherwise this
  //model will not work under OpenModelica 1.9.2.
  Modelica.Blocks.Interfaces.RealInput torqueReq annotation (
    Placement(transformation(extent = {{-140, 40}, {-100, 80}}), iconTransformation(extent = {{-140, 40}, {-100, 80}})));
  Modelica.Blocks.Interfaces.RealInput wMech annotation (
    Placement(transformation(extent = {{-140, -80}, {-100, -40}}), iconTransformation(extent = {{-140, -80}, {-100, -40}})));
  Modelica.Blocks.Interfaces.RealOutput Id annotation (
    Placement(transformation(extent = {{100, 50}, {120, 70}}), iconTransformation(extent = {{100, 50}, {120, 70}})));
  Modelica.Blocks.Interfaces.RealOutput Iq annotation (
    Placement(transformation(extent = {{100, -70}, {120, -50}}), iconTransformation(extent = {{100, -70}, {120, -50}})));
  Modelica.Blocks.Interfaces.RealInput uDC "DC voltage" annotation (
    Placement(transformation(extent = {{-140, -20}, {-100, 20}})));
equation
  //Computations with full flux.
  //Computation of  Id, Iq, Vd, Vq, V
  IparkFF = torqueReq / (1.5 * pp * Psi);
  IdFF = 0;
  IqFF = IparkFF;
  VdFF = Rs * IdFF - w * Ld * IqFF;
  VqFF = Rs * IqFF + w * Psi;
  VparkFF = sqrt(VdFF ^ 2 + VqFF ^ 2);
  if VparkFF < Ulim then
    weakening = 0;
    //weakening should be boolean. It is assumed to be real because otherwise this
    //model will not work under OpenModelica 1.9.2.
    0 = gammaStar;
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
    Vd = Rs * Id - w * Ld * Iq;
    Vq = Rs * Iq + w * (Psi + Ld * Id);
    Vpark = sqrt(Vd ^ 2 + Vq ^ 2);
    Vpark = Ulim;
    //   gammaFilt+tauFilt*der(gammaFilt)=gammaStar;
  end if;
  torqueReq = 1.5 * pp * Psi * Ipark * cos(gammaStar);
  assert(gammaStar < 0.98 * PI / 2, "\n***\nmaximum gamma reached\n***\n");
  annotation (
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1,
        grid={2,2}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),Text(
                extent={{-100,142},{100,106}},
                lineColor={0,0,127},
                textString="%name"),Text(
                extent={{-98,28},{98,-28}},
                lineColor={0,0,127},
                textString="MTPAi")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}},
    preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})));
end MTPAi;
