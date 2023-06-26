CLASS lhc_devteam DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR devteam RESULT result.

    METHODS setactive FOR MODIFY
      IMPORTING keys FOR ACTION devteam~setactive RESULT result.

    METHODS changesalary FOR DETERMINE ON SAVE
      IMPORTING keys FOR devteam~changesalary.

    METHODS validateage FOR VALIDATE ON SAVE
      IMPORTING keys FOR devteam~validateage.

ENDCLASS.


""" 3 EML statements to use ( Read / Modify / Commit )..
CLASS lhc_devteam IMPLEMENTATION.

  METHOD get_instance_features.

    "" once the user setActive we want to disable the button
    "" read active flag of the existing members
    READ ENTITIES OF zcds_devteam_01 IN LOCAL MODE
    ENTITY devteam
    FIELDS ( Active ) WITH CORRESPONDING #( keys )
    RESULT DATA(members)
    FAILED failed .


"" disable the button incase it is active
    result =
    VALUE #(
     FOR member IN members

     LET status = COND #( WHEN member-active = abap_true
                          THEN if_abap_behv=>fc-o-disabled
                          ELSE if_abap_behv=>fc-o-enabled )

                          IN
                          ( %tky =  member-%tky
                          %action-setactive = status ) ) .

  ENDMETHOD.

  METHOD setactive.

    MODIFY ENTITIES OF zcds_devteam_01 IN LOCAL MODE
    ENTITY devteam
    UPDATE FIELDS ( Active ) WITH VALUE #( FOR key IN keys (
    %tky = key-%tky
    Active = abap_true ) )

    FAILED failed
    REPORTED reported .

    "" fill response table
    READ ENTITIES OF zcds_devteam_01 IN LOCAL MODE
    ENTITY devteam
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(members) .

    result = VALUE #( FOR member IN members
                       ( %tky = member-%tky
                         %param = member ) ) .

  ENDMETHOD.

  METHOD changesalary.

    "" salary only changed if you change the role
    READ ENTITIES OF zcds_devteam_01 IN LOCAL MODE
    ENTITY devteam
    FIELDS ( Role ) WITH CORRESPONDING #( keys )
    RESULT DATA(members) .

    LOOP AT members INTO DATA(member) .
      IF member-role = 'JR Developer' .

        ""change salary with the key / value
        MODIFY ENTITIES OF zcds_devteam_01 IN LOCAL MODE
        ENTITY devteam
        UPDATE FIELDS ( Salary )
        WITH VALUE #(  ( %tky = member-%tky
                         Salary = 8000 ) ) .

      ENDIF .

      IF member-role = 'SR Developer' .

        ""change salary with the key / value
        MODIFY ENTITIES OF zcds_devteam_01 IN LOCAL MODE
        ENTITY devteam
        UPDATE FIELDS ( Salary )
        WITH VALUE #(  ( %tky = member-%tky
                         Salary = 20000 ) ) .

      ENDIF .

      IF member-role = 'Development Lead' .

        ""change salary with the key / value
        MODIFY ENTITIES OF zcds_devteam_01 IN LOCAL MODE
        ENTITY devteam
        UPDATE FIELDS ( Salary )
        WITH VALUE #(  ( %tky = member-%tky
                         Salary = 35000 ) ) .

      ENDIF .


    ENDLOOP.


  ENDMETHOD.

  METHOD validateage.

    " read the age using EML
    READ ENTITIES OF zcds_devteam_01 IN LOCAL MODE
    ENTITY devteam
    FIELDS ( Age ) WITH CORRESPONDING #( keys )
    RESULT DATA(members) .

    LOOP AT members INTO DATA(member) .
      IF member-age < 21 .
        "" adding to the failed structure, the save is aborted
        APPEND VALUE #( %tky = member-%tky ) TO failed-devteam .
      ENDIF. .
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
