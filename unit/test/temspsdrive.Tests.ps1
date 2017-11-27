Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module Projects | Remove-Module -Force

Import-Module SHiPS

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force

InModuleScope Projects {

   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe "TeamsPSDrive" {

      # Load the mocks to create the project name dynamic parameter
      . "$PSScriptRoot\mockProjectDynamicParamMandatoryFalse.ps1"

      Mock Invoke-RestMethod { return @{ value = @{} } }

      # https://info.sapien.com/index.php/scripting/scripting-classes/import-powershell-classes-from-modules
      $scriptBody = "using module $PSScriptRoot\..\..\src\teamspsdrive.psm1"
      $script = [ScriptBlock]::Create($scriptBody)
      . $script

      Context 'VSAccount' {

         $target = [VSAccount]::new('TestAccount')

         It 'Should create VSAccount' {
            $target | Should Not Be $null
         }

         It 'Should return projects' {
            #Set-PSDebug -Trace 1
            $target.GetChildItem() | Should Not Be $null
         }

         AfterAll {
            Set-PSDebug -Off
         }
      }

      Context 'Project' {

         $target = [Project]::new('TestProject', '123', '')

         It 'Should create Project' {
            $target | Should Not Be $null
         }
      }

      Context 'Builds' {

         $target = [Builds]::new('TestBuild', 'TestProject')

         It 'Should create Builds' {
            $target | Should Not Be $null
         }
      }

      Context 'Release' {
         
         $target = [Release]::new('TestReleaseId', 'TestReleaseName', 'TestReleaseStatus', 'TestUser', '1/1/2017', @())
         
         It 'Should create Release' {
            $target | Should Not Be $null
         }
      }


      Context 'Teams' {
         
         $target = [Teams]::new('TestTeamsName', 'TestProject')
         
         It 'Should create Teams' {
            $target | Should Not Be $null
         }
      }

      Context 'Team' {
         
         $target = [Team]::new('TestTeamId', 'TestTeamName', 'TestProject', '')
         
         It 'Should create Team' {
            $target | Should Not Be $null
         }
      }
   }
}