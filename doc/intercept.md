

# Module intercept #
* [Description](#description)
* [Data Types](#types)
* [Function Index](#index)
* [Function Details](#functions)

Copyright (c) 2015 Basho Technologies, Inc.

<a name="description"></a>

## Description ##

This file is provided to you under the Apache License,
Version 2.0 (the "License"); you may not use this file
except in compliance with the License.  You may obtain
a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
<a name="types"></a>

## Data Types ##




### <a name="type-fun_name">fun_name()</a> ###


<pre><code>
fun_name() = atom()
</code></pre>




### <a name="type-fun_type">fun_type()</a> ###


<pre><code>
fun_type() = <a href="#type-fun_name">fun_name()</a> | tuple()
</code></pre>




### <a name="type-intercept_fun">intercept_fun()</a> ###


<pre><code>
intercept_fun() = <a href="#type-fun_type">fun_type()</a>
</code></pre>




### <a name="type-mapping">mapping()</a> ###


<pre><code>
mapping() = <a href="#type-proplist">proplist</a>(<a href="#type-target_fun">target_fun()</a>, <a href="#type-intercept_fun">intercept_fun()</a>)
</code></pre>




### <a name="type-proplist">proplist()</a> ###


<pre><code>
proplist(K, V) = <a href="proplists.md#type-proplist">proplists:proplist</a>(K, V)
</code></pre>




### <a name="type-target_fun">target_fun()</a> ###


<pre><code>
target_fun() = {<a href="#type-fun_name">fun_name()</a>, arity()}
</code></pre>

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#add-3">add/3</a></td><td>
Add intercepts against the <code>Target</code> module.</td></tr><tr><td valign="top"><a href="#add-4">add/4</a></td><td></td></tr><tr><td valign="top"><a href="#clean-1">clean/1</a></td><td>
Cleanup proxy and backuped original module.</td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="add-3"></a>

### add/3 ###

<pre><code>
add(Target::module(), Intercept::module(), Mapping::<a href="#type-mapping">mapping()</a>) -&gt; ok
</code></pre>
<br />

Add intercepts against the `Target` module.

`Target` - The module on which to intercept calls.
E.g. `hashtree`.

`Intercept` - The module containing intercept definitions.
E.g. `hashtree_intercepts`

`Mapping` - The mapping from target functions to intercept
functions.

E.g. `[{{update_perform,2}, sleep_update_perform}]`

<a name="add-4"></a>

### add/4 ###

<pre><code>
add(Target::module(), Intercept::module(), Mapping::<a href="#type-mapping">mapping()</a>, OutDir::string()) -&gt; ok
</code></pre>
<br />

<a name="clean-1"></a>

### clean/1 ###

<pre><code>
clean(Target::module()) -&gt; ok | {error, term()}
</code></pre>
<br />

Cleanup proxy and backuped original module

