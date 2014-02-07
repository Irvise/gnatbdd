-----------------------------------------------------------------------------
--                             G N A T C O L L                              --
--                                                                          --
--                     Copyright (C) 2014, AdaCore                          --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

--  A feature and its scenarios.

with Ada.Containers.Doubly_Linked_Lists;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package BDD.Features is

   ----------
   -- Step --
   ----------

   type Step_Record (<>) is tagged private;
   type Step is access all Step_Record'Class;

   procedure Set_Text
     (Self : not null access Step_Record'Class; Text : String);
   --  Set the text of the step

   procedure Free (Self : in out Step_Record);
   procedure Free (Self : in out Step);
   --  Free the memory associated with Self

   --------------
   -- Scenario --
   --------------

   type Scenario_Record is tagged private;
   type Scenario is access all Scenario_Record'Class;
   --  A scenario to be run within a feature

   procedure Free (Self : in out Scenario_Record);
   procedure Free (Self : in out Scenario);
   --  Free the memory associated with Self

   type Scenario_Kind is (Kind_Scenario, Kind_Background, Kind_Outline);

   procedure Set_Attributes
     (Self  : not null access Scenario_Record;
      Kind  : Scenario_Kind;
      Name  : String;
      Line  : Positive;
      Index : Positive);
   --  Set the line of the feature file at which the scenario is defined, and
   --  its index within its Feature.

   function Name  (Self : not null access Scenario_Record) return String;
   function Line  (Self : not null access Scenario_Record) return Positive;
   function Index (Self : not null access Scenario_Record) return Positive;
   function Kind
     (Self : not null access Scenario_Record) return Scenario_Kind;
   --  Retrieve the attributes of Self

   procedure Add
     (Self : not null access Scenario_Record;
      S    : not null access Step_Record'Class);
   --  Add a new step

   -------------
   -- Feature --
   -------------

   type Feature is tagged limited private;
   --  An object that represents a single feature and all its scenarios.
   --  A specific features file might contain several features, but this object
   --  only represents one of them.

   procedure Free (Self : in out Feature);
   --  Free the memory associated with Self

   procedure Set_Unique_Id (Self : in out Feature; Id : Integer);
   function Id (Self : Feature) return Integer;
   --  Set a unique id for the feature

   procedure Set_Name (Self : in out Feature; Name : String);
   function Name (Self : Feature) return String;
   --  The name of the feature

   procedure Set_File
     (Self : in out Feature; File : GNATCOLL.VFS.Virtual_File);
   function File (Self : Feature) return GNATCOLL.VFS.Virtual_File;
   --  The file in which the feature is defined

   function Description (Self : Feature) return String;
   procedure Add_Description (Self : in out Feature; Descr : String);
   --  Add some description information. Add_Description will be called once
   --  for each line in the description.

private
   type Step_Record is tagged record
      Text      : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   package Step_Lists is new Ada.Containers.Doubly_Linked_Lists (Step);
   type Step_List is new Step_Lists.List with null record;
   overriding procedure Clear (List : in out Step_List);

   type Scenario_Record is tagged record
      Name      : Ada.Strings.Unbounded.Unbounded_String;
      Line      : Positive := 1;
      Index     : Positive := 1;
      Kind      : Scenario_Kind := Kind_Scenario;
      Steps     : Step_List;
   end record;
   --  Make sure this type can be put in a list and automatically reclaim
   --  storage when the list is clearer.

   type Feature is tagged limited record
      File        : GNATCOLL.VFS.Virtual_File;
      Name        : GNAT.Strings.String_Access;
      Id          : Integer;
      Description : Ada.Strings.Unbounded.Unbounded_String;
   end record;
end BDD.Features;
