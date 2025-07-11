//go:build !ignore_autogenerated
// +build !ignore_autogenerated

/*
Copyright 2023 The EdgeFarm Authors.

Licensed under the Mozilla Public License, version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.mozilla.org/en-US/MPL/2.0/

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by controller-gen. DO NOT EDIT.

package natsbackend

import ()

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *IssueAccountParameters) DeepCopyInto(out *IssueAccountParameters) {
	*out = *in
	in.Claims.DeepCopyInto(&out.Claims)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new IssueAccountParameters.
func (in *IssueAccountParameters) DeepCopy() *IssueAccountParameters {
	if in == nil {
		return nil
	}
	out := new(IssueAccountParameters)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *IssueOperatorParameters) DeepCopyInto(out *IssueOperatorParameters) {
	*out = *in
	in.Claims.DeepCopyInto(&out.Claims)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new IssueOperatorParameters.
func (in *IssueOperatorParameters) DeepCopy() *IssueOperatorParameters {
	if in == nil {
		return nil
	}
	out := new(IssueOperatorParameters)
	in.DeepCopyInto(out)
	return out
}

// DeepCopyInto is an autogenerated deepcopy function, copying the receiver, writing into out. in must be non-nil.
func (in *IssueUserParameters) DeepCopyInto(out *IssueUserParameters) {
	*out = *in
	in.ClaimsTemplate.DeepCopyInto(&out.ClaimsTemplate)
}

// DeepCopy is an autogenerated deepcopy function, copying the receiver, creating a new IssueUserParameters.
func (in *IssueUserParameters) DeepCopy() *IssueUserParameters {
	if in == nil {
		return nil
	}
	out := new(IssueUserParameters)
	in.DeepCopyInto(out)
	return out
}
