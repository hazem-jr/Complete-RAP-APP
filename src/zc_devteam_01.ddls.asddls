@Search.searchable: true
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DevTeam Consumption View'

define root view entity zc_devteam_01
  as projection on zcds_devteam_01 as DevTeam
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Firs Name'
      @Search.defaultSearchElement: true
      Firstname,
      @EndUserText.label: 'Last Name'
      @Search.defaultSearchElement: true
      Lastname,
      @EndUserText.label: 'Age'
      Age,
      @EndUserText.label: 'Role'
      @Search.defaultSearchElement: true
      Role,
      @EndUserText.label: 'Salary'
      Salary,
      @EndUserText.label: 'Active'
      Active,
      LastChangedAt,
      LocalLastChangedAt
}
