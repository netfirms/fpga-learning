library ieee;
use ieee.std_logic_1164.all;

entity SwitchDrivesLED is
port
(
	sw1:in std_logic;
	led1:out std_logic;
	sw2:in std_logic;
	led2:out std_logic;
	sw3:in std_logic;
	led3:out std_logic;
	sw4:in std_logic;
	led4:out std_logic
);
end entity;

architecture rtl of SwitchDrivesLED is

begin
	led1<=sw1;
	led2<=sw2;
	led3<=sw3;
	led4<=sw4;
end rtl;
