Feature: A first feature
   This is not very useful, we are just testing that we can execute basic
   calculator tests.

   Background:
      Given an empty calculator

   Scenario: Simple additions
      When I enter "1"
      And I enter "2"
      And I enter "+"
      Then I should read 3

   Scenario Outline: testing operators
      When I enter "<first>"
      And I enter "<second>"
      And I enter "<operation>"
      Then I should read <result>
      Examples:
         | first  | second | operation | result |
         |  10    |  20    |   +       | 30     |
         |  20    |  10    |   -       | 10     |
         |  10    |  20    |   +       | 40     |
