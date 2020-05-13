### ERP CLI Tool

## Inspiration for this tool
---
Postman is great but we have to make multiple calls
and manually copy/paste 

Postman is ineffecient for complex API logic

Solve complex or time consuming PSI using the APIs

## What it should do
---
- X handle oauth tokens 
- X handle refresh of token before each command / script 

## First functionalities
--- 
- psi note command that generates structure
  -- prompts to create a new dir or "link to existing psi note dir"
  -- dir:PSI_number/file:PSI_number w/ requires, gem file.
- return ERP id <==> procore ids
- reset ERP sync event
- reset CCOS
(speak w/ psi team about next 3 features)


## People who use this:
---
Dev team 
PSI team


## Interface
---
> eprtool COMMAND ARGS 
> ERPTOOL PROMT (keeps asking until you say no more.)


## Thoughts
---
- Keep interface is CLI
- abstract interface 
- logic that is in the scirpts should build as service classes for future implementation to MicroServices.
- think about 3rd party integrators that use procore api ( they may need to reset their PCCOs )


### TODOs
X use tty-prompt to display project name
X use tty-config to create a config file somewhere

---
X  change config file to be placed in users home path
X  fix oath flow to ask for auth_code from generated URL using the serverless redirect_uri 
    prompt :
      client_id
      client_secret
      use lanchy to open url for user to copy paste auth_code after login
      uses auth_code to get token, refresh_token, created_at, expire_time and write to file
      get refresh token to work as a helper method

  X Stop sync event using /rest/v0/
    build in a way that can be 'exported' into MS


  X Create PSI comand that takes --link and --init flags
    it will throw an error if there is not path set in the config
    it will save this psi_notes_path in the config file
    it will create a psi_notes dir in home path when init is used
    it will set the location of psi_notes to path when --link is used
    it will create a .erptool_gemspec file that includes gems for either --link or --init
      gems to include: json, httpary, pry-byebug, csv, awesome_print
    it will prompt for psi link, comany name, psi number and then create a file from that

  PCCO cmd
    subcommands:
    DETAILS - 
      Given a Company ID , Project ID, PCCO ID 
      return all details about the PC & PCCO & Line items, such as origin ids and status

      ouputs:
      table PC
        id
        origin id
        status
        erp id
       - table PC Line Items
          id
          origin id
          status
        
      table PCCO
        id
        origin id
        status
        - table PCCO Line Items
          id
          origin id
          status









